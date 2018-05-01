
struct TagCollection: Codable {
        
    var tags: [String]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: KeysCodable.self)
        
        self.tags = try container.decode([String].self, forKey: .tags)
    }
    
    init(with tags: [String]){
        self.tags = tags
    }
}

extension TagCollection {
    enum KeysCodable: String, CodingKey {
        case tags = "tags"
    }
}
