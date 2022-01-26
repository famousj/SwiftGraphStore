import Foundation
import SwiftGraphStore
import UrsusHTTP

extension Post {
    public static var testInstance: Post {
        Post(author: Ship.testInstance,
             index: Index.testInstance,
             timeSent: Date(),
             contents: [],
             hash: nil,
             signatures: [])
    }
}
