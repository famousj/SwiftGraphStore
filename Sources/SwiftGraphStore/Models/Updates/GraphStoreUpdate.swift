import Foundation

public struct GraphStoreUpdate: Codable, Equatable {
    public let graphUpdate: GraphUpdate
    
    enum CodingKeys: String, CodingKey {
        case graphUpdate = "graph-update"
    }
}
