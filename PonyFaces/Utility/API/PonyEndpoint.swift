
import Alamofire

public enum PonyEndpoint: CachingEndpoint {
    
    case getTags
    case getPonysByTag
    case getPonyImage
    
    public var HTTPMethod: HTTPMethod {
        return .get
    }
    
    public var path: String {
        var path = ""
        
        switch self {
            case .getTags: path = "api.json/tags"
            case .getPonysByTag: path = "api.json/tag:<tag>"
            case .getPonyImage: path = "<id>/<size>"
        }
        return "http://ponyfaces.hpcodecraft.me/" + path
    }
    
    public var encoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    public var expirationTime: TimeInterval {
        return 900
    }
    
    public var cachingEnabled: Bool {
        return true
    }
}
