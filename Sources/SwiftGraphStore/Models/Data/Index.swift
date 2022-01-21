import Foundation

// TODO: allow this index to be based off a @da, instead of a swift `Date`
struct Index {
    let value: UInt64
        
    init(value: UInt64) {
        self.value = value
    }
}

extension Index {
    init(date: Date = .now) {
        self.init(value: UInt64(date.timeIntervalSinceReferenceDate * 1000))
    }
}

extension Index {
    init?(_ string: String) {
        guard let stringValue = Self.valueFromString(string: string) else {
            return nil
        }
        value = stringValue
    }
    
    var stringWithSeparators: String {
        Self.formatterWithDotSeparators.string(from: NSNumber(value: value)) ?? ""
    }
    
    var string: String {
        String(value)
    }

    private static func valueFromString(string: String) -> UInt64? {
        let number = formatterWithDotSeparators.number(from: string)
        return number?.uint64Value
    }

    private static var formatterWithDotSeparators: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "it_IT")
        numberFormatter.numberStyle = .decimal
        return numberFormatter
    }
}

extension Index: Equatable {}

extension Index: Hashable {}

extension Index: Comparable {
    static func < (lhs: Index, rhs: Index) -> Bool {
        lhs.value < rhs.value
    }
}

extension Index: CustomStringConvertible {
    var description: String {
        String(value)
    }
}
