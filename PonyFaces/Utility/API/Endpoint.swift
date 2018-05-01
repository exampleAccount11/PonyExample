import Alamofire

public protocol Endpoint {
    var HTTPMethod: HTTPMethod { get }
    var path: String { get }
    var encoding: ParameterEncoding { get }
}

public protocol CachingEndpoint: Endpoint {
    var expirationTime: TimeInterval { get }
    var cachingEnabled: Bool { get }
}
