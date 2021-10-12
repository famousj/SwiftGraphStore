import Foundation
import UrsusHTTP

// TODO: Make this into a real type that validates that it is %actually-a-term
public typealias Term = String

struct Resource: Codable, Equatable {
    let ship: Ship
    let name: Term
}
