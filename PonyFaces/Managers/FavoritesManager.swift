import Cache

class Favorites {
    
    static let shared = Favorites()
    
    var favorites: [Pony] {
        
        get {
            guard let cachedPonies = Caching.shared?.get(type: [Pony].self, forKey: "PonyFavorites") else {
                return [Pony]()
            }
            return cachedPonies.object
        }
        
        set {
            Caching.shared?.set(object: newValue, forKey: "PonyFavorites", expiry: .never)
        }
    }
    
    func addPony(pony: Pony) {
        
        var cachedPonies: [Pony] = favorites
        cachedPonies.append(pony)
        favorites = cachedPonies
    }
    
    func remove(removePony: Pony) {
        
        let updatedPonies: [Pony] = favorites.filter { $0 != removePony }
        favorites = updatedPonies
    }
    
    func isFavorited(pony: Pony) -> Bool {
        for ponyFav in favorites {
            if ponyFav == pony {
                return true
            }
        }
        
        return false
    }
}
