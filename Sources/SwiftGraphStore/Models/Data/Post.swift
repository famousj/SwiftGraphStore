import Foundation
import UrsusHTTP

public struct Post: Codable, Equatable {
    let author: Ship
    let index: String
    let timeSent: Date
    @NullCodable var contents: [Content]?
    @NullCodable var hash: Int?
    @NullCodable var signatures: [Signature]?
//    [author=~zod index=~2021.10.16..04.01.29..14ea time-sent=~2000.1.1 contents=~ hash=~ signatures={}]
    
    enum CodingKeys: String, CodingKey {
        case author, index, contents, hash, signatures
        case timeSent = "time-sent"
    }
}

struct Signature: Codable, Equatable { }
