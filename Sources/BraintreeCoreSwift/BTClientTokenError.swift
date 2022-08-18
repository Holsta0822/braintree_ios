import Foundation

///  Error codes associated with a client token.
@objc public enum BTClientTokenError: Int, Error, CustomNSError, LocalizedError {

    /// Authorization fingerprint was not present or invalid
    case invalidAuthorizationFingerprint

    /// Config URL was missing or invalid
    case invalidConfigURL

    /// Invalid JSON
    case invalidJSON

    /// Invalid client token format
    case invalidFormat

    /// Unsupported client token version
    case unsupportedVersion
    
    /// Invalid UTF8 Encoding
    case expectedUTF8Encoding
    
    /// Invalid Base64 Encoding
    case expectedBase64Encoding

    public static var errorDomain: String {
        "com.braintreepayments.BTClientTokenErrorDomain"
    }

    public var errorCode: Int {
        rawValue
    }
    
    public var errorDescription: String? {
        switch self {
        case .invalidAuthorizationFingerprint:
            return "Invalid client token. Please ensure your server is generating a valid Braintree ClientToken. Authorization fingerprint was not present or invalid."
        case .invalidConfigURL:
            return "Invalid client token: config URL was missing or invalid. Please ensure your server is generating a valid Braintree ClientToken."
        case .invalidJSON:
            return "Invalid client token. Please ensure your server is generating a valid Braintree ClientToken. Invalid JSON. Expected to find an object at JSON root."
        case .invalidFormat:
            return "Invalid client token format. Please pass the client token string directly as it is generated by the server-side SDK. Unsupported client token format."
        case .unsupportedVersion:
            return "Unsupported client token version. Please ensure your server is generating a valid Braintree ClientToken with a server-side SDK that is compatible with this version of Braintree iOS."
        case .expectedUTF8Encoding:
            return "Invalid client token. Expected UTF8 encoding but found Base64. Client token version 1 must be encoded using UTF8"
        case .expectedBase64Encoding:
            return "Invalid client token. Expected Base64 encoding but found UTF8. Client token versions 2 & 3 must be encoded using Base64."
        }
    }
}