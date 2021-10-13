import Foundation

public struct GraphUpdate: Codable, Equatable {
    let addGraph: AddGraph
    
    enum CodingKeys: String, CodingKey {
        case addGraph = "add-graph"
    }
}
