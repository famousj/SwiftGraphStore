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
}
