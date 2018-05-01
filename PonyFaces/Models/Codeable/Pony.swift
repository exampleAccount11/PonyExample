
class Pony: Codable, Equatable {
    
    // MARK: - Properties
    var identifier: String
    var views: String
    var link: String
    var thumb: String
    var full: String
    var tags: [String]
    
    enum KeysCodable: String, CodingKey {
        case identifier = "id"
        case views = "views"
        case link = "link"
        case thumb = "thumbnail"
        case tags = "tags"
        case full = "image"
    }
    
    required init(from aDecoder: Decoder) throws  {
        let container = try aDecoder.container(keyedBy: KeysCodable.self)
        
        self.identifier = try container.decode(String.self, forKey: .identifier)
        self.views = try container.decode(String.self, forKey: .views)
        self.link = try container.decode(String.self, forKey: .link)
        self.thumb = try container.decode(String.self, forKey: .thumb)
        self.tags = try container.decode(Array.self, forKey: .tags)
        self.full = try container.decode(String.self, forKey: .full)
    }
    
    static func == (lhs: Pony, rhs: Pony) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

extension Pony {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: KeysCodable.self)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(views, forKey: .views)
        try container.encode(link, forKey: .link)
        try container.encode(thumb, forKey: .thumb)
        try container.encode(tags, forKey: .tags)
        try container.encode(full, forKey: .full)
    }
}
