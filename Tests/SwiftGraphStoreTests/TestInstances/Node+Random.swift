import Foundation
import SwiftGraphStore

extension Node {
    static var testInstance: Node {
        Node(post: Post.testInstance, children: nil)
    }
}
