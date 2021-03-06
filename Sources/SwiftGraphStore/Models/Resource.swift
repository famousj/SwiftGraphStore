import Foundation
import UrsusHTTP

public typealias Term = String

public struct Resource: Codable, Equatable, Identifiable {
    public let ship: Ship
    public let name: Term
    
    public init(ship: Ship, name: Term) {
        self.ship = ship
        self.name = name
    }
    
    public var id: String {
        "\(ship)/\(name)"
    }
}
