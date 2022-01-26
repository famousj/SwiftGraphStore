import Foundation
import SwiftGraphStore
import UrsusHTTP

internal extension GraphUpdate {
    static var addGraphTestInstance: GraphUpdate {
        let resource = Resource.testInstance
        let graph = Graph.testInstance
        return .addGraph(resource: resource,
                         graph: graph,
                         mark: nil,
                         overwrite: true)
    }
    
    static var addNodesTestInstance: GraphUpdate {
        let resource = Resource.testInstance
        let node = Node.testInstance
        let index = node.post.index
        return .addNodes(resource: resource, nodes: [index: node])
    }
    
    static var keysTestInstance: GraphUpdate {
        let count = Int.random(in: 0...5)
        let keys = (0...count).map { _ in Resource.testInstance }        
        return .keys(keys)
    }
}
