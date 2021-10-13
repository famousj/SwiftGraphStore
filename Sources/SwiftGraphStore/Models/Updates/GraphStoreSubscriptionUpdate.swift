import Foundation

public struct GraphStoreSubscriptionUpdate: Codable, Equatable {
    let graphUpdate: GraphUpdate
    
    enum CodingKeys: String, CodingKey {
        case graphUpdate = "graph-update"
    }
}
