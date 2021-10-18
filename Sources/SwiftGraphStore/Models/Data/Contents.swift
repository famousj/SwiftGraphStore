import Foundation

// TODO: Make this an enum that works with the $% on the Urbit-side
public struct Content: Codable, Equatable {
    public let text: String
    
    public init(text: String) {
        self.text = text
    }
}
