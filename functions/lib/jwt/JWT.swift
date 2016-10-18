import Foundation
// mw:import CryptoSwift

// mw:public typealias Payload = [String: Any]

/// The supported Algorithms
public enum Algorithm : CustomStringConvertible {
  /// No Algorithm, i-e, insecure
  case none

  /// HMAC using SHA-256 hash algorithm
  case hs256(Data)

  /// HMAC using SHA-384 hash algorithm
  case hs384(Data)

  /// HMAC using SHA-512 hash algorithm
  case hs512(Data)

  public var description:String {
    switch self {
    case .none:
      return "none"
    case .hs256:
      return "HS256"
    case .hs384:
      return "HS384"
    case .hs512:
      return "HS512"
    }
  }

  /// Sign a message using the algorithm
  func sign(_ message:String) -> String {
    // mw:
    func signHS(_ key: Data, variant:/*CryptoSwift.*/HMAC.Variant) -> String {
      let messageData = message.data(using: String.Encoding.utf8, allowLossyConversion: false)!
      // mw:let mac = HMAC(key: key.bytes, variant:variant)
      let byteArray = key.withUnsafeBytes {
        [UInt8](UnsafeBufferPointer(start: $0, count: key.count))
      }
      let mac = HMAC(key: byteArray, variant:variant)
      let result: [UInt8]
      do {
        // mw:result = try mac.authenticate(messageData.bytes)
        let byteArray = messageData.withUnsafeBytes {
          [UInt8](UnsafeBufferPointer(start: $0, count: messageData.count))
        }
        result = try mac.authenticate(byteArray)
      } catch {
        result = []
      }
      // mw:added Base64().
      return Base64().base64encode(Data(bytes: result))
    }

    switch self {
    case .none:
      return ""

    case .hs256(let key):
      return signHS(key, variant: .sha256)

    case .hs384(let key):
      return signHS(key, variant: .sha384)

    case .hs512(let key):
      return signHS(key, variant: .sha512)
    }
  }

  /// Verify a signature for a message using the algorithm
  func verify(_ message:String, signature:Data) -> Bool {
    // mw:added Base64().
    return sign(message) == Base64().base64encode(signature)
  }
}

// mw:added class
class JWT {

// MARK: Encoding

/*** Encode a payload
  - parameter payload: The payload to sign
  - parameter algorithm: The algorithm to sign the payload with
  - returns: The JSON web token as a String
*/
public func encode(_ payload:[String: Any], algorithm:Algorithm) -> String {
  func encodeJSON(_ payload:[String: Any]) -> String? {
    if let data = try? JSONSerialization.data(withJSONObject: payload, options: JSONSerialization.WritingOptions(rawValue: 0)) {
      // mw:added Base64().
      return Base64().base64encode(data)
    }

    return nil
  }

  // mw:
  let header = encodeJSON(["typ": "JWT"/* as AnyObject*/, "alg": algorithm.description/* as AnyObject*/])!
  let payload = encodeJSON(payload)!
  let signingInput = "\(header).\(payload)"
  let signature = algorithm.sign(signingInput)
  return "\(signingInput).\(signature)"
}

// mw:moved from bottom
public func encode(_ algorithm:Algorithm, closure:((PayloadBuilder) -> ())) -> String {
  let builder = PayloadBuilder()
  closure(builder)
  return encode(builder.payload, algorithm: algorithm)
}

} // mw:

open class PayloadBuilder {
  var payload = [String: Any]()

  open var issuer:String? {
    get {
      return payload["iss"] as? String
    }
    set {
      payload["iss"] = newValue // mw:as AnyObject? as AnyObject?
    }
  }

  open var audience:String? {
    get {
      return payload["aud"] as? String
    }
    set {
      payload["aud"] = newValue // mw:as AnyObject?
    }
  }

  open var expiration:Date? {
    get {
      if let expiration = payload["exp"] as? TimeInterval {
        return Date(timeIntervalSince1970: expiration)
      }

      return nil
    }
    set {
      payload["exp"] = newValue?.timeIntervalSince1970 // mw: as AnyObject?
    }
  }

  open var notBefore:Date? {
    get {
      if let notBefore = payload["nbf"] as? TimeInterval {
        return Date(timeIntervalSince1970: notBefore)
      }

      return nil
    }
    set {
      payload["nbf"] = newValue?.timeIntervalSince1970 // mw: as AnyObject?
    }
  }

  open var issuedAt:Date? {
    get {
      if let issuedAt = payload["iat"] as? TimeInterval {
        return Date(timeIntervalSince1970: issuedAt)
      }

      return nil
    }
    set {
      payload["iat"] = newValue?.timeIntervalSince1970 // mw: as AnyObject?
    }
  }

  open subscript(key: String) -> Any {
    get {
      return payload[key]
    }
    set {
      payload[key] = newValue
    }
  }
}

// mw: moved int JWT class
// public func encode(_ algorithm:Algorithm, closure:((PayloadBuilder) -> ())) -> String {
//   let builder = PayloadBuilder()
//   closure(builder)
//   return encode(builder.payload, algorithm: algorithm)
// }
// mw:do not remove the following empty line

