import Foundation
import SwiftGraphStore

extension Graph {
    public static var testInstance: Graph {
        let nodeCount = (1...5).randomElement()!
        
        var graph = Graph()
        (0..<nodeCount).forEach { _ in
            graph[Atom.testInstance] = Node.testInstance
        }
        return graph
    }
}
