import Foundation
import SwiftGraphStore
import UrsusHTTP

internal extension Resource {
    static var testInstance: Resource {
        Resource(ship: Ship.random, name: UUID().uuidString)
    }
}
