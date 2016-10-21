import Dispatch
import Foundation
import KituraNet
import SwiftyJSON

// $DefaultParam:couchdb
// $DefaultParam:jwt_secret

func main(args: [String:Any]) -> [String:Any] {
    let db = "users"
    let couchdbClient = getCouchdbClient(args: args)
    let emailAddress = args["email_address"]
    let password = args["password"]
    if (emailAddress != nil && password != nil) {
        var response : [String:Any]?
        DispatchQueue.global().sync {
            let query = [
                "selector" : [
                    "email_address" : emailAddress,
                    "password": password
                ]
            ]
            couchdbClient.findDocs(db: db, query: query) { (docs, error) in
                if (error != nil || docs == nil || docs?.count != 1) {
                    response = ["error": "Invalid email address or password.", "docs": docs]
                }
                else {
                    let user = docs![0] as! [String:Any]
                    let jwtSecret = args["jwt_secret"] as! String
                    let jwt = JWT().encode(["id": user["_id"]], algorithm: .hs256(jwtSecret.data(using: .utf8)!))
                    response = ["user": user, "jwt": jwt]
                }
            }
        }
        return response!
    }
    else {
        return ["error": "Invalid email address or password."]
    }
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
{% include "./lib/crypto/CollectionExtensions.swift" %}
{% include "./lib/crypto/Digest.swift" %}
{% include "./lib/crypto/HMAC.swift" %}
{% include "./lib/crypto/NumberExtensions.swift" %}
{% include "./lib/crypto/SHA2.swift" %}
{% include "./lib/crypto/Utils.swift" %}
{% include "./lib/crypto/ZeroPadding.swift" %}
{% include "./lib/jwt/Base64.swift" %}
{% include "./lib/jwt/Claims.swift" %}
{% include "./lib/jwt/Decode.swift" %}
{% include "./lib/jwt/JWT.swift" %}
