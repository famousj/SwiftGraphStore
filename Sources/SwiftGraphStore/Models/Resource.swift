import Foundation
import UrsusHTTP

// TODO: Make this into a real type that validates that it is %actually-a-term
public typealias Term = String

struct Resource: Codable {
    let ship: Ship
    let name: Term
}
