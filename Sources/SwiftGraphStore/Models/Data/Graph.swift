import Foundation

public struct Graph: Codable, Equatable {

    public let post: Post
    @NullCodable public var children: [String: Graph]?
    
    public init(post: Post, children: [String: Graph]?) {
        self.post = post
        self.children = children
    }
}
