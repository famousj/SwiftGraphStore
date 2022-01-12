import Foundation

public struct GraphStoreUpdate: Codable, Equatable {
    public let graphUpdate: GraphUpdate

    public init(graphUpdate: GraphUpdate) {
        self.graphUpdate = graphUpdate
    }
    
    enum CodingKeys: String, CodingKey {
        case graphUpdate = "graph-update"
    }
}
