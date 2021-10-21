import Foundation
import SwiftGraphStore
import UrsusHTTP

internal extension GraphUpdate {
    static var addGraphTestInstance: GraphUpdate {
        let resource = Resource.testInstance
        let graph = Graph.testInstance
        let index = graph.post.index
        return .addGraph(resource: resource,
                         graph: [index: graph],
                         mark: nil,
                         overwrite: true)
    }
    
    static var addNodesTestInstance: GraphUpdate {
        let resource = Resource.testInstance
        let graph = Graph.testInstance
        let index = graph.post.index
        return .addNodes(resource: resource, nodes: [index: graph])
    }
}
