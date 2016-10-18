import Dispatch
import Foundation
import KituraNet
import SwiftyJSON

// $DefaultParam:couchdb
// $DefaultParam:jwt_secret

func main(args: [String:Any]) -> [String:Any] {
    if (args["keep_alive"] as? Bool == true) {
        return ["keep_alive": "true"]
    }
    let db = "users"
    let couchdbClient = getCouchdbClient(args: args)
    let jwt = args["jwt"] as? String
    if (jwt != nil) {
        let jwtSecret = args["jwt_secret"] as! String
        var response : [String:Any]?
        do {
            let payload = try Decode().decode(jwt!, algorithm: .hs256(jwtSecret.data(using: .utf8)!))
            let userId = payload["id"]
            DispatchQueue.global().sync {
                let query = [
                    "selector": [
                        "_id": userId
                    ]
                ]
                couchdbClient.findDocs(db: db, query: query) { (docs, error) in
                    if (error != nil || docs == nil || docs?.count != 1) {
                        response = ["error" : "User not found."]
                    }
                    else {
                        response = docs![0] as? [String:Any]
                    }
                }
            }
        }
        catch {
            response = ["error" : "Invalid token."]
        }
        return response!
    }
    else {
        return ["error" : "Invalid token."]
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
