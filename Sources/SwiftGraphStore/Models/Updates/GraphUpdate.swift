import Foundation
import UrsusHTTP

public enum GraphUpdate: Codable, Equatable {
    
    case addGraph(resource: Resource,
                  graph: [Index: Node],
                  mark: Mark?,
                  overwrite: Bool)
    case addNodes(resource: Resource,
                  nodes: [Index: Node])
    case keys(Keys)
    
    enum CodingKeys: String, CodingKey {
        case addGraph = "add-graph"
        case addNodes = "add-nodes"
        
        case keys
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
            let graphDict = Index.convertIndexDictionary(graph)
            try addGraphContainer.encode(graphDict, forKey: .graph)
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
            let nodesDict = Index.convertIndexDictionary(nodes)
            try addNodesContainer.encode(nodesDict, forKey: .nodes)
        case let .keys(keys):
            try container.encode(keys, forKey: .keys)
        }
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let keys = try? container.decode(Keys.self, forKey: .keys) {
            self = .keys(keys)
            return
        }
        
        if let addGraphContainer = try? container.nestedContainer(keyedBy: AddGraphCodingKeys.self, forKey: .addGraph) {
            let resource = try addGraphContainer.decode(Resource.self, forKey: .resource)
   
            let graph: [Index: Node]
            do {
                let graphDict = try addGraphContainer.decode([String: Node].self, forKey: .graph)
                graph = try Index.convertStringDictionary(graphDict)
            } catch {
                throw DecodingError.dataCorruptedError(Index.self,
                                                       at: [AddGraphCodingKeys.graph],
                                                       in: addGraphContainer)
            }
            let mark = try addGraphContainer.decodeIfPresent(Mark.self, forKey: .mark)
            let overwrite = try addGraphContainer.decode(Bool.self, forKey: .overwrite)
            
            self = .addGraph(resource: resource,
                             graph: graph,
                             mark: mark,
                             overwrite: overwrite)
            return
        }
        
        let addNodesContainer = try container.nestedContainer(keyedBy: AddNodesCodingKeys.self, forKey: .addNodes)
        let resource = try addNodesContainer.decode(Resource.self, forKey: .resource)
        let nodes: [Index: Node]
        do {
            let nodesDict = try addNodesContainer.decode([String: Node].self, forKey: .nodes)
            nodes = try Index.convertStringDictionary(nodesDict)
        } catch {
            throw DecodingError.dataCorruptedError(Index.self,
                                                   at: [AddNodesCodingKeys.nodes],
                                                   in: addNodesContainer)
        }
        self = .addNodes(resource: resource, nodes: nodes)
    }    
}

extension GraphUpdate: Identifiable {
    public var id: String {
        switch self {
        case .addGraph(let resource, _, _, _):
            return resource.id
        case .addNodes(let resource, _):
            return resource.id
        case .keys(let keys):
            return keys.first?.id ?? ""
        }
    }
}
