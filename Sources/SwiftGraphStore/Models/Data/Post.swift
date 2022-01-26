import Foundation
import UrsusHTTP

public struct Post: Codable, Equatable {
    public let author: Ship
    public let index: Index
    public let timeSent: Date
    public var contents: [Content]
    @NullCodable public var hash: Int?
    public var signatures: [Signature]
    
    public init(author: Ship, index: Index, timeSent: Date, contents: [Content], hash: Int?, signatures: [Signature]) {
        self.author = author
        self.index = index
        self.timeSent = timeSent
        self.contents = contents
        self.hash = hash
        self.signatures = signatures
    }
    
    enum CodingKeys: String, CodingKey {
        case author, index, contents, hash, signatures
        case timeSent = "time-sent"
    }
}
