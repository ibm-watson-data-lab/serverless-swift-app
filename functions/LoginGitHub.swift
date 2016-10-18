import Dispatch
import Foundation
import KituraNet
import LoggerAPI
import SwiftyJSON

// $DefaultParam:jwt_secret
// $DefaultParam:oauth_client_id
// $DefaultParam:oauth_client_secret

func main(args: [String:Any]) -> [String:Any] {
    if (args["keep_alive"] as? Bool == true) {
        return ["keep_alive": "true"]
    }
    var response : [String: Any]?
    DispatchQueue.global().sync {
        var options: [ClientRequest.Options] = []
        options.append(.schema("https://"))
        options.append(.hostname("github.com"))
        options.append(.path("/login/oauth/access_token"))
        options.append(.method("POST"))
        let body = "client_id=\(args["oauth_client_id"]!)&client_secret=\(args["oauth_client_secret"]!)&code=\(args["code"]!)"
        let req = HTTP.request(options) { res in
            if (res != nil && res!.statusCode == HTTPStatusCode.OK) {
                // Encode the access token using jwt and return to the client
                // The jwt token can be passed from the client back to the server to make calls against GitHub
                do {
                    var data: Data = Data()
                    try res!.readAllData(into: &data)
                    var accessToken = String(data:data, encoding:.utf8)!
                    accessToken = accessToken.substring(from: (accessToken.range(of: "access_token=")?.upperBound)!)
                    accessToken = accessToken.substring(to: (accessToken.range(of: "&")?.lowerBound)!)
                    let jwtSecret = args["jwt_secret"] as! String
                    let jwt = JWT().encode(["access_token": accessToken], algorithm: .hs256(jwtSecret.data(using: .utf8)!))
                    response = ["jwt": jwt, "access_token": accessToken]
                }
                catch {
                    response = ["error": "\(error)"]
                }
            }
            else {
                response = ["error": "Error connecting to GitHub"]
            }
        }
        req.write(from: body)
        req.end()
    }
    return response!
}

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
