import Foundation
import SwiftGraphStore

extension Node {
    public static var testInstance: Node {
        return Node(post: Post.testInstance, children: nil)
    }
}
