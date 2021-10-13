import Foundation

public struct AddGraph: Codable, Equatable {
    let resource: Resource
    let graph: Graph
    let mark: String
    let overwrite: Bool
}

public struct Graph: Codable, Equatable {}
