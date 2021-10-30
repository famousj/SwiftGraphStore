import Foundation
import SwiftGraphStore

extension Graph {
    static var testInstance: Graph {
        Graph(post: Post.testInstance, children: nil)
    }
}
