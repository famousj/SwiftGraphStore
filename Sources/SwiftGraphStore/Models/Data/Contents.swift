import Foundation

public struct Content: Codable, Equatable {
    public let text: String
    
    public init(text: String) {
        self.text = text
    }
}
