import Foundation

/// Makes an Encodable and Decodable properties encode to `null` instead of omitting the value altogether.
@propertyWrapper
public struct NullCodable<T> {
    public var wrappedValue: T?

    public init(wrappedValue: T?){
        self.wrappedValue = wrappedValue
    }
}

extension NullCodable: Encodable where T: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch wrappedValue {
        case .some(let value):
            try container.encode(value)
        case .none:
            try container.encodeNil()
        }
    }
}

extension NullCodable: Decodable where T: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.wrappedValue = try? container.decode(T.self)
    }
}

extension NullCodable: Equatable where T: Equatable { }
