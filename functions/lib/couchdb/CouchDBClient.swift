import Foundation
import KituraNet
import LoggerAPI

public enum CouchDBError: Swift.Error {
    case EmptyResponse
}

public class CouchDBClient {
    
    var scheme = "http"
    var port = 80
    var host: String
    var username: String?
    var password: String?
    
    public init(host: String) {
        self.host = host
    }
    
    public init(host: String, username: String?, password: String?) {
        self.host = host
        self.username = username
        self.password = password
    }

    public init(host: String, scheme: String, port: Int) {
        self.host = host
        self.scheme = scheme
        self.port = port
    }
    
    public init(host: String, scheme: String, port: Int, username: String?, password: String?) {
        self.host = host
        self.scheme = scheme
        self.port = port
        self.username = username
        self.password = password
    }

    // MARK: db

    public func createDbIfNotExists(db: String, completionHandler: @escaping (CouchDBCreateDbResponse?, Swift.Error?) -> Void) {
        let options = self.createHeadRequest(db: db, path: "")
        print("HEAD /.")
        let req = HTTP.request(options) { response in
            if (response != nil && response!.statusCode == HTTPStatusCode.OK) {
                completionHandler(CouchDBCreateDbResponse(ok:true), nil)
            }
            else {
                self.createDb(db:db, completionHandler:completionHandler)
            }
        }
        req.end()
    }
    
    public func createDb(db: String, completionHandler: @escaping (CouchDBCreateDbResponse?, Swift.Error?) -> Void) {
        let options = self.createPutRequest(db: db, path: "")
        print("PUT /.")
        let req = HTTP.request(options) { response in
            do {
                print("Received response for /.")
                let dict: [String:Any]? = try self.parseResponse(response: response, error: nil)
                if (dict != nil) {
                    completionHandler(CouchDBCreateDbResponse(dict:dict!), nil)
                }
                else {
                    completionHandler(nil, nil)
                }
            }
            catch {
                completionHandler(nil, error)
            }
        }
        req.end()
    }

    public func createDoc(db: String, doc: [String: Any], completionHandler: @escaping (CouchDBSaveDocResponse?, Swift.Error?) -> Void) {
        do {
            let body = try JSONSerialization.data(withJSONObject:doc, options: [])
            let options = self.createPostRequest(db: db, path: "")
            print("POST /.")
            let req = HTTP.request(options) { response in
                do {
                    print("Received response for /.")
                    let dict: [String:Any]? = try self.parseResponse(response: response, error: nil)
                    if (dict != nil) {
                        completionHandler(CouchDBSaveDocResponse(dict:dict!), nil)
                    }
                    else {
                        completionHandler(nil, nil)
                    }
                }
                catch {
                    completionHandler(nil, error)
                }
            }
            req.write(from: body)
            req.end()
         }
         catch {
            completionHandler(nil, error)
        }
    }

    // MARK: find

    public func findDocs(db: String, query: [String:Any], completionHandler: @escaping ([Any]?, Swift.Error?) -> Void) {
        do {
            let body = try JSONSerialization.data(withJSONObject: query, options: [])
            let options = self.createPostRequest(db: db, path: "_find")
            print("POST _find.")
            let req = HTTP.request(options) { response in
                do {
                    print("Received response for _find.")
                    let dict: [String:Any]? = try self.parseResponse(response: response, error: nil)
                    if (dict != nil) {
                        if let docs = dict!["docs"] as? [[String:Any]] {
                            completionHandler(docs, nil)
                        }
                        else {
                            completionHandler(nil, nil)
                        }
                    }
                    else {
                        completionHandler(nil, nil)
                    }
                }
                catch {
                    completionHandler(nil, error)
                }
            }
            req.write(from: body)
            req.end()
        }
        catch {
            completionHandler(nil, error)
        }
    }
    
    // MARK: _all_docs
    
    public func getAllDocs(db: String, completionHandler: @escaping ([Any]?, Swift.Error?) -> Void) {
        let options = self.createGetRequest(db: db, path: "_all_docs")
        print("GET _all_docs.")
        let req = HTTP.request(options) { response in
            do {
                print("Received response for _all_docs.")
                let dict: [String:Any]? = try self.parseResponse(response: response, error: nil)
                if (dict != nil) {
                    if let rows = dict!["rows"] as? [[String:Any]] {
                        completionHandler(rows, nil)
                    }
                    else {
                        completionHandler(nil, nil)
                    }
                }
                else {
                    completionHandler(nil, nil)
                }
            }
            catch {
                completionHandler(nil, error)
            }
        }
        req.end()
    }
    
    // MARK: Helper Functions
    
    func createGetRequest(db: String, path: String) -> [ClientRequest.Options] {
        var options: [ClientRequest.Options] = self.createRequest(db: db, path: path)
        options.append(.method("GET"))
        return options
    }

    func createPostRequest(db: String, path: String) -> [ClientRequest.Options] {
        var options: [ClientRequest.Options] = self.createRequest(db: db, path: path)
        options.append(.method("POST"))
        return options
    }

    func createPutRequest(db: String, path: String) -> [ClientRequest.Options] {
        var options: [ClientRequest.Options] = self.createRequest(db: db, path: path)
        options.append(.method("PUT"))
        return options
    }

    func createHeadRequest(db: String, path: String) -> [ClientRequest.Options] {
        var options: [ClientRequest.Options] = self.createRequest(db: db, path: path)
        options.append(.method("HEAD"))
        return options
    }

    func createRequest(db: String, path: String) -> [ClientRequest.Options] {
        var headers = [String:String]()
        headers["Content-Type"] = "application/json"
        headers["Accept"] = "application/json"
        if (self.username != nil && self.password != nil) {
            let loginString = "\(self.username!):\(self.password!)"
            let loginData: Data? = loginString.data(using:String.Encoding.utf8)
            let base64LoginString = loginData!.base64EncodedString(options:[])
            headers["Authorization"] = "Basic \(base64LoginString)"
        }
        var options: [ClientRequest.Options] = []
        options.append(.headers(headers))
        options.append(.schema("\(self.scheme)://"))
        options.append(.hostname(self.host))
        options.append(.port(Int16(port)))
        options.append(.path("/\(db)/\(path)"))
        return options
    }
    
    func parseResponse(response:ClientResponse?, error:NSError?) throws -> [String:Any]? {
        if (error != nil) {
            throw error!
        }
        else if (response == nil) {
            print("Empty response.")
            throw CouchDBError.EmptyResponse
        }
        else {
            let str = try response!.readString()!
            print("Response = \(str)")
            if (str.characters.count > 0) {
                return try JSONSerialization.jsonObject(with:str.data(using:String.Encoding.utf8)!, options:[]) as? [String:Any]
            }
            else {
                return nil
            }
        }
    }

    func parseResponseAsArray(response:ClientResponse?, error:NSError?) throws -> [Any]? {
        if (error != nil) {
            throw error!
        }
        else if (response == nil) {
            print("Empty response.")
            throw CouchDBError.EmptyResponse
        }
        else {
            let str = try response!.readString()!
            print("Response = \(str)")
            if (str.characters.count > 0) {
                return try JSONSerialization.jsonObject(with:str.data(using:String.Encoding.utf8)!, options:[]) as? [Any]
            }
            else {
                return nil
            }
        }
    }
    
}