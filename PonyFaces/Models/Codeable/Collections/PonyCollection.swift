

struct PonyCollection: Codable {
    
    var ponys: [Pony]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: KeysCodable.self)
        
        self.ponys = try container.decode([Pony].self, forKey: .ponys)
    }
    
    init(with ponies: [Pony]){
        self.ponys = ponies
    }
}

extension PonyCollection {
    enum KeysCodable: String, CodingKey {
        case ponys = "faces"
    }
}
