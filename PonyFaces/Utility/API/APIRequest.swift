
import Alamofire
import PromiseKit
import Cache

struct APIRequest {
    var body: [String: Any] {
        
        var params: [String: Any] = [:]
        for param in parameters.body {
            params[param.key] = param.value
        }
        return params
    }
    
    // Initialized Properties
    let endpoint: Endpoint
    let parameters: Parameters
    let createdAt: Date
    var urlString: String = ""
    let cacheKey: String = ""
    
    // Initialization
    init(with endpoint: Endpoint, parameters: Parameters) {
        self.endpoint = endpoint
        self.parameters = parameters
        self.createdAt = Date()
        self.urlString = buildRequestURL()
    }
}

// MARK: - Helpers
fileprivate extension APIRequest {
    
    func buildRequestURL() -> String {
        
        // build
        var finalPath = endpoint.path
        
        // loop through params
        for parameter in parameters.path {
            
            // build regex for param to replace key
            let pattern = "(<\(parameter.key)>)"
            
            // encode value for http
            guard let encodedValue = parameter.value.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
                return endpoint.path
            }
            
            // replace/<this>/ with encoded value
            finalPath = finalPath.replacingOccurrences(of: pattern, with: "\(encodedValue)", options: .regularExpression)
        }
        
        // Build Query Params
        var encodedParams: [String] = []
        for param in parameters.query {
            guard let encodedName = param.key.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
                let encodedValue = param.value.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
                    return finalPath
            }
            encodedParams.append("\(encodedName)=\(encodedValue)")
        }
        if encodedParams.count > 0 {
            finalPath = finalPath.appending("?")
        }
        return finalPath + encodedParams.joined(separator: "&")
    }
    
    func set(key: String, with value: String, for string: String ) -> String {
        return string.replacingOccurrences(of: "<\(key)>", with: value)
    }
}

