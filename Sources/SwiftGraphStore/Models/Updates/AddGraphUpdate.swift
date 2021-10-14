import Foundation

public struct AddGraphUpdate: Codable, Equatable {
    public let resource: Resource
    public let graph: Graph
    public let mark: String?
    public let overwrite: Bool
}

public struct Graph: Codable, Equatable {}
