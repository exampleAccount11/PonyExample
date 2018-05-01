

import Alamofire
import PromiseKit

class PonyAPIClient: API {
    class func bustCache() {
        Caching.shared?.removeAllObjects()
    }
}


// MARK: - FTUES
extension PonyAPIClient {
    
    class func getPonysByTag(tag: String) -> Promise<[Pony]> {
        
        let endpoint = PonyEndpoint.getPonysByTag
        
        let parameters = Parameters(path: [Parameter("tag", tag)])
        
        return firstly {
            API.genericRequest(with: endpoint, parameters: parameters, decodeType: PonyCollection.self) as Promise<PonyCollection>
        }.then { pony -> [Pony] in
            return pony.ponys
        }
    }
    
    class func getTags() -> Promise<[String]> {
        
        let endpoint = PonyEndpoint.getTags
        
        return firstly {
            API.genericRequest(with: endpoint, parameters: Parameters(), decodeType: TagCollection.self) as Promise<TagCollection>
        }.then { tags -> [String] in
            return tags.tags
        }
    }
}
