import Foundation

public struct Node {

    public let post: Post
    @NullCodable public var children: [Index: Node]?
    
    public init(post: Post, children: [Index: Node]?) {
        self.post = post
        self.children = children
    }
}

extension Node: Equatable {}

extension Node: Codable {
    enum CodingKeys: String, CodingKey {
        case post, children
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(post, forKey: .post)
        
        var childrenDict: [String: Node]?
        if let children = children {
            childrenDict = Index.convertIndexDictionary(children)
        }
        try container.encode(childrenDict, forKey: .children)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let post = try container.decode(Post.self, forKey: .post)
        var children: [Index: Node]?
        do {
            if let childrenDict = try container.decode([String: Node]?.self, forKey: .children) {
                children = try Index.convertStringDictionary(childrenDict)
            }
            
        } catch {
            throw DecodingError.dataCorruptedError(Index.self,
                                                   at: [CodingKeys.children],
                                                   in: container)
        }
        
        self = .init(post: post, children: children)
    }
}
