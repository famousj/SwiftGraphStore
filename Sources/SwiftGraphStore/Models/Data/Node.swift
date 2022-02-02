import Foundation

public struct Node {

    public let post: Post
    @NullCodable public var children: Graph?
    
    public init(post: Post, children: Graph?) {
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
            childrenDict = children.asStringDictionary()
        }
        try container.encode(childrenDict, forKey: .children)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let post = try container.decode(Post.self, forKey: .post)
        var children: Graph?
        do {
            if let childrenDict = try container.decode([String: Node]?.self, forKey: .children) {
                children = try childrenDict.asGraph()
            }
            
        } catch {
            throw DecodingError.dataCorruptedError(Index.self,
                                                   at: [CodingKeys.children],
                                                   in: container)
        }
        
        self = .init(post: post, children: children)
    }
}
