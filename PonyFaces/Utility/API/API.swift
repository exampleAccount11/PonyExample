
import Alamofire
import PromiseKit
import Cache

class API: NSObject {
    
    fileprivate class var manager: SessionManager {
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 30
        return manager
    }
}


extension API {
    
    class func genericRequest<T>(with endpoint: Endpoint, parameters: Parameters, decodeType: T.Type) -> Promise<T> where T: Codable {
        
        let request = APIRequest(with: endpoint, parameters: parameters)
        
        if let endpoint = endpoint as? CachingEndpoint, endpoint.cachingEnabled,
            let entry = Caching.shared?.get(type: decodeType, forKey: request.urlString) {
            return Promise(value: entry.object)
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        return firstly {
            manager.request(request.urlString, method: endpoint.HTTPMethod, parameters: request.body, encoding: endpoint.encoding, headers: nil).response()
            }.then { (urlRequest: URLRequest, urlResponse: HTTPURLResponse, data: Data) in
                let decoded = try JSONDecoder().decode(decodeType, from: data)
                
                if let endpoint = endpoint as? CachingEndpoint, endpoint.cachingEnabled {
                    Caching.shared?.set(object: decoded, forKey: request.urlString, expiry: .date(Date().addingTimeInterval(endpoint.expirationTime)))
                }
                return Promise(value:decoded)
            }.recover { error -> T in
                throw error
            }.always {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}


