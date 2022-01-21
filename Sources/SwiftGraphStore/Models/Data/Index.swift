import Foundation
import BigInt

// TODO: allow this index to be based off a @da, instead of a swift `Date`
public struct Index {
    let value: BigUInt
    
    public init(value: BigUInt) {
        self.value = value
    }
}

extension Index: RawRepresentable {
    public var rawValue: String {
        string
    }
    
    public init?(rawValue: String) {
        guard let stringValue = Self.valueFromString(string: rawValue) else {
            return nil
        }
        value = stringValue
    }
}

extension Index {
    public init(date: Date = .now) {
        self.init(value: BigUInt(date.timeIntervalSinceReferenceDate * 1000))
    }
}

extension Index {
    public init?(_ string: String) {
        self.init(rawValue: string)
    }
    
    public var stringWithSeparators: String {
        string.split(every: 3).joined(separator: ".")
    }
    
    public var string: String {
        String(value)
    }
    
    private static func valueFromString(string: String) -> BigUInt? {
        var valueString = string.split(separator: ".").joined()
        if string.starts(with: "/") {
            let count = string.count
            valueString = String(string.suffix(count-1))
        }
        return BigUInt(valueString)
    }
    
    public static func convertStringDictionary<T>(_ dict: [String: T]) throws -> [Index: T] {
        var newDict = [Index: T]()
        try dict.forEach { (key, value) in
            guard let indexKey = Index(key) else {
                throw NSError()
            }
            newDict[indexKey] = value
        }
        return newDict
    }
    
    public static func convertIndexDictionary<T>(_ dict: [Index: T]) -> [String: T] {
        var newDict = [String: T]()
        dict.forEach { (key, value) in
            newDict[key.string] = value
        }
        return newDict
    }
}

extension Index: Codable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        value = Self.valueFromString(string: stringValue) ?? 0
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.string)
    }
}

extension Index: Equatable {}

extension Index: Hashable {
    public func hash(into hasher: inout Hasher) {
        value.hash(into: &hasher)
    }
}

extension Index: Comparable {
    public static func < (lhs: Index, rhs: Index) -> Bool {
        lhs.value < rhs.value
    }
}

extension Index: CustomStringConvertible {
    public var description: String {
        String(value)
    }
}

fileprivate extension String {
    func split(every: Int) -> [String] {
        var result = [String]()
        for i in stride(from: 0, to: self.count, by: every) {
            let endIndex = self.index(self.endIndex, offsetBy: -i)
            let startIndex = self.index(endIndex, offsetBy: -every, limitedBy: self.startIndex) ?? self.startIndex
            result.insert(String(self[startIndex..<endIndex]), at: 0)
        }
        return result
    }
}
