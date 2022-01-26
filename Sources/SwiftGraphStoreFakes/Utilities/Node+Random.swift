import Foundation
@testable import SwiftGraphStore

extension Node {
    static var testInstance: Node {
        return Node(post: Post.testInstance, children: nil)
    }
}
