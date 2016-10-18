import Dispatch
import Foundation
import KituraNet
import SwiftyJSON

// $DefaultParam:couchdb

func main(args: [String:Any]) -> [String:Any] {
    if (args["keep_alive"] as? Bool == true) {
        return ["keep_alive": "true"]
    }
    let db = "users"
    let couchdbClient = getCouchdbClient(args: args)
    var response : [String:Any]?
    DispatchQueue.global().sync {
        couchdbClient.createDbIfNotExists(db: db) { (createDbResponse, error) in
            if (error != nil) {
                response = ["error": "Error creating database."]
            }
            else {
                let doc = [
                    "email_address": args["email_address"],
                    "password": args["password"],
                    "first_name": args["first_name"],
                    "last_name":  args["last_name"]
                ]
                couchdbClient.createDoc(db: db, doc: doc) { (saveDocResponse, error) in
                    if (error != nil || saveDocResponse == nil) {
                       response = ["error": "Error registering user."]
                    }
                    else {
                        response = doc
                        response?["_id"] = saveDocResponse!.id
                        response?["_rev"] = saveDocResponse!.rev
                    }
                }
            }
        }
    }
    return response!
}

func getCouchdbClient(args: [String:Any]) -> CouchDBClient {
    let couchdbConfig = args["couchdb"] as! [String:Any]
    return CouchDBClient(
        host: couchdbConfig["host"] as! String,
        scheme: couchdbConfig["scheme"] as! String,
        port: couchdbConfig["port"] as! Int,
        username: couchdbConfig["username"] as? String,
        password: couchdbConfig["password"] as? String
    )
}

{% include "./lib/couchdb/CouchDBCreateDbResponse.swift" %}
{% include "./lib/couchdb/CouchDBSaveDocResponse.swift" %}
{% include "./lib/couchdb/CouchDBClient.swift" %}