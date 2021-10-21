import Foundation

public enum GraphUpdate: Codable, Equatable {

    case addGraph(resource: Resource,
                  graph: [String: Graph],
                  mark: String?,
                  overwrite: Bool)
    case addNodes(resource: Resource,
                  nodes: [String: Graph])

    
    enum CodingKeys: String, CodingKey {
        case addGraph = "add-graph"
        case addNodes = "add-nodes"
    }
    
    enum AddGraphCodingKeys: String, CodingKey {
        case resource, graph, mark, overwrite
    }
    
    enum AddNodesCodingKeys: String, CodingKey {
        case resource, nodes
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case let .addGraph(resource, graph, mark, overwrite):
            var addGraphContainer = container.nestedContainer(keyedBy: AddGraphCodingKeys.self, forKey: .addGraph)
            try addGraphContainer.encode(resource, forKey: .resource)
            try addGraphContainer.encode(graph, forKey: .graph)
            switch mark {
            case .some(let value):
                try addGraphContainer.encode(value, forKey: .mark)
            case .none:
                try addGraphContainer.encodeNil(forKey: .mark)
            }
            try addGraphContainer.encode(overwrite, forKey: .overwrite)
        case let .addNodes(resource, nodes):
            var addNodesContainer = container.nestedContainer(keyedBy: AddNodesCodingKeys.self, forKey: .addNodes)
            try addNodesContainer.encode(resource, forKey: .resource)
            try addNodesContainer.encode(nodes, forKey: .nodes)
        }
    }
}
