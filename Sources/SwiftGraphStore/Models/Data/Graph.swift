import Foundation

public struct Graph: Codable, Equatable {

    public let post: Post
    // TODO: This is actually the `internal-graph` type.  Which is not quite the same as a graph.  As things are written, this should always be null.
    @NullCodable public var children: [Graph]?
}
