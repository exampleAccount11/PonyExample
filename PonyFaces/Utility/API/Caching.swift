
import Cache

class Caching {
    
    // Static Properties
    fileprivate let storage: Storage
    static let shared = Caching()
    
    private init?() {
        do {
            self.storage = try Storage(diskConfig:DiskConfig(name: "APIStorage"), memoryConfig: MemoryConfig())
        } catch {
            return nil
        }
    }
    
    public func set<T: Codable>(object: T, forKey: String, expiry: Expiry? = nil) {
        do {
            try self.storage.setObject(object, forKey: forKey, expiry: expiry)
        } catch {
            NSLog("failed")
        }
    }
    
    public func get<T: Codable>(type: T.Type, forKey: String) -> Entry<T>? {
        do {
            
            let entry = try self.storage.entry(ofType: type, forKey: forKey)
            if entry.expiry.isExpired {
                self.removeObject(for: forKey)
                return nil
            } else {
                return entry
            }
            
        } catch {
            return nil
        }
    }
    
    public func removeObject(for key: String) {
        do {
            try self.storage.removeObject(forKey: key)
        } catch {
        }
    }
    
    public func removeAllObjects() {
        do {
            try self.storage.removeAll()
        } catch {
        }
    }
}

