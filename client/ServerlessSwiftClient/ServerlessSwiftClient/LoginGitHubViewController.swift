//
//  LoginGitHubViewController.swift
//  ServerlessSwiftClient
//
//  Created by Mark Watson on 10/14/16.
//  Copyright © 2016 IBM CDS Labs. All rights reserved.
//

import SwiftyJSON
import UIKit

class LoginGitHubViewController: UIViewController, UIWebViewDelegate {
    
    private static let GITHUB_ENDPOINT = "https://github.com/login/oauth/authorize?client_id=81392868896edc1d2120"
    
    @IBOutlet var webView: UIWebView!
    
    var activityIndicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let url = URL(string: LoginGitHubViewController.GITHUB_ENDPOINT)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        self.webView.loadRequest(request)
    }
    
    @IBAction func closeButtonPressed(sender: UIButton) {
        self.dismiss(animated: true) {
        }
    }
    
    // MARK: UIWebViewDelegate
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("webViewDidStartLoad")
        self.waitingForResponse()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("webViewDidFinishLoad")
        self.doneWaitingForResponse()
        let content = webView.stringByEvaluatingJavaScript(from: "document.body.innerText")
        if (content?.range(of: "jwt") != nil) {
            let json = JSON(data: content!.data(using: .utf8)!)
            if let jwt = json["jwt"].string {
                AppDelegate.jwt = jwt
                self.dismiss(animated: true) {
                }
            }
        }
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("webViewDidFailLoadWithError")
        self.doneWaitingForResponse()
    }
    
    // MARK: Helper Functions
    
    func waitingForResponse() {
        self.activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.height))
        self.activityIndicator?.activityIndicatorViewStyle = .whiteLarge
        self.activityIndicator?.backgroundColor = UIColor.black
        self.activityIndicator?.alpha = 0.5
        self.activityIndicator?.startAnimating()
        self.view.isUserInteractionEnabled = false
        self.view.addSubview(self.activityIndicator!)
    }
    
    func doneWaitingForResponse() {
        self.activityIndicator?.removeFromSuperview()
        self.view.isUserInteractionEnabled = true
    }
    
    func showResponse(message:String) {
        let alertController = UIAlertController(title:"Response", message:message, preferredStyle:.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}
