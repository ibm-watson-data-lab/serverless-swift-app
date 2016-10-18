//
//  LoginViewController.swift
//  ServerlessSwiftClient
//
//  Created by Mark Watson on 10/11/16.
//  Copyright © 2016 IBM CDS Labs. All rights reserved.
//

import SwiftyJSON
import UIKit

class LoginViewController: UIViewController {
    
    private static let OPENWHISK_ENDPOINT = "https://openwhisk.ng.bluemix.net/api/v1/namespaces/markwats%40us.ibm.com_serverless-swift-talk/actions/Login?blocking=true"
    private static let API_CONNECT_ENDPOINT = "https://api.us.apiconnect.ibmcloud.com/markwatsusibmcom-serverless-swift-talk/sb/api/login"
    
    @IBOutlet var openWhiskAuthHeaderTextField: UITextField!
    @IBOutlet var openWhiskEmailAddressTextField: UITextField!
    @IBOutlet var openWhiskPasswordTextField: UITextField!
    @IBOutlet var apiConnectEmailAddressTextField: UITextField!
    @IBOutlet var apiConnectPasswordTextField: UITextField!
    
    var activityIndicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let authHeader = UserDefaults.standard.value(forKey: AppDelegate.OPENWHISK_AUTH_HEADER_KEY) as? String
        if (authHeader != nil) {
            self.openWhiskAuthHeaderTextField.text = authHeader
        }
    }
    
    // MARK: OpenWhisk Endpoint
    
    @IBAction func openWhiskRunButtonPressed(sender: UIButton) {
        let emailAddress = self.openWhiskEmailAddressTextField.text
        let password = self.openWhiskPasswordTextField.text
        let authHeader = self.openWhiskAuthHeaderTextField.text
        if (authHeader == nil) {
            return
        }
        // save authHeader
        UserDefaults.standard.setValue(authHeader, forKey: AppDelegate.OPENWHISK_AUTH_HEADER_KEY)
        // call OpenWhisk
        let url = URL(string: LoginViewController.OPENWHISK_ENDPOINT)
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.addValue(authHeader!, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField:"Content-Type")
        request.addValue("application/json", forHTTPHeaderField:"Accepts")
        request.httpMethod = "POST"
        if (emailAddress != nil && password != nil) {
            let json: JSON = [
                "email_address": emailAddress!,
                "password": password!
            ]
            do {
                request.httpBody = try json.rawData()
            }
            catch {
                print("Error serializing JSON: \(error)")
            }
        }
        //
        self.waitingForResponse()
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                self.doneWaitingForResponse()
                guard let _:Data = data, let _:URLResponse = response, error == nil else {
                    print("Error connecting to OpenWhisk: \(error)")
                    return
                }
                let json = JSON(data: data!)
                if let reply = json["response"]["result"]["jwt"].string {
                    AppDelegate.jwt = reply
                    self.showResponse(message: "\(reply)")
                }
            }
        });
        task.resume()
    }
    
    // MARK: API Connect Endpoint
    
    @IBAction func apiConnectRunButtonPressed(sender: UIButton) {
        let emailAddress = self.apiConnectEmailAddressTextField.text
        let password = self.apiConnectPasswordTextField.text
        // call API Connect
        let url = URL(string: LoginViewController.API_CONNECT_ENDPOINT)
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.addValue("application/json", forHTTPHeaderField:"Content-Type")
        request.addValue("application/json", forHTTPHeaderField:"Accepts")
        request.httpMethod = "POST"
        if (emailAddress != nil && password != nil) {
            let json: JSON = [
                "email_address": emailAddress!,
                "password": password!
            ]
            do {
                request.httpBody = try json.rawData()
            }
            catch {
                print("Error serializing JSON: \(error)")
            }
        }
        //
        self.waitingForResponse()
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                self.doneWaitingForResponse()
                guard let _:Data = data, let _:URLResponse = response, error == nil else {
                    print("Error connecting to OpenWhisk: \(error)")
                    return
                }
                let json = JSON(data: data!)
                if let reply = json["jwt"].string {
                    AppDelegate.jwt = reply
                    self.showResponse(message: "\(reply)")
                }
            }
        });
        task.resume()
    }
    
    // MARK: Helper Functions
    
    func waitingForResponse() {
        self.activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.height))
        self.activityIndicator?.activityIndicatorViewStyle = .whiteLarge
        self.activityIndicator?.backgroundColor = UIColor.black
        self.activityIndicator?.alpha = 0.5
        self.activityIndicator?.startAnimating()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController?.view.isUserInteractionEnabled = false
        appDelegate.window?.rootViewController?.view.addSubview(self.activityIndicator!)
    }
    
    func doneWaitingForResponse() {
        self.activityIndicator?.removeFromSuperview()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController?.view.isUserInteractionEnabled = true
    }
    
    func showResponse(message:String) {
        let alertController = UIAlertController(title:"Response", message:message, preferredStyle:.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}
