import Foundation

// TODO: allow this index to be based off a @da, instead of a swift `Date`
public struct Index {
    let value: UInt64
    
    public init(value: UInt64) {
        self.value = value
    }
}

extension Index {
    public init(date: Date = .now) {
        self.init(value: UInt64(date.timeIntervalSinceReferenceDate * 1000))
    }
}

extension Index {
    public init?(_ string: String) {
        guard let stringValue = Self.valueFromString(string: string) else {
            return nil
        }
        value = stringValue
    }
    
    public var stringWithSeparators: String {
        Self.formatterWithDotSeparators.string(from: NSNumber(value: value)) ?? ""
    }
    
    public var string: String {
        String(value)
    }
    
    private static func valueFromString(string: String) -> UInt64? {
        var valueString = string
        if string.starts(with: "/") {
            let count = string.count
            valueString = String(string.suffix(count-1))
        }
        let number = formatterWithDotSeparators.number(from: valueString)
        return number?.uint64Value
    }
    
    private static var formatterWithDotSeparators: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "it_IT")
        numberFormatter.numberStyle = .decimal
        return numberFormatter
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
        hasher.combine(value)
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
