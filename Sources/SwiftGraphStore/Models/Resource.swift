import Foundation
import UrsusHTTP

// TODO: Make this into a real type that validates that it is %actually-a-term
public typealias Term = String

public struct Resource: Codable, Equatable, Identifiable {
    public let ship: Ship
    public let name: Term
    
    // TODO: Test this
    public var id: String {
        "\(ship)/\(name)"
    }
}
