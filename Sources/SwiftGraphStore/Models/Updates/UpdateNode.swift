import Foundation

public struct UpdateNode: Codable, Equatable {
    public let post: Post
    // TODO: This is actually the `internal-graph` type.  Which is not a graph.
    @NullCodable public var children: [Graph]?
}
