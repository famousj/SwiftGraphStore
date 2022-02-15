import Foundation
import SwiftGraphStore
import UrsusHTTP

extension Resource {
    public static var testInstance: Resource {
        Resource(ship: Ship.testInstance, name: UUID().uuidString)
    }
}
