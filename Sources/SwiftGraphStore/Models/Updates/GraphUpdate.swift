import Foundation

public struct GraphUpdate: Codable, Equatable {
    public let addGraph: AddGraphUpdate
    
    enum CodingKeys: String, CodingKey {
        case addGraph = "add-graph"
    }
}
