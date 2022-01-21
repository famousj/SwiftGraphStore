import Foundation

// TODO: allow this index to be based off a @da, instead of a swift `Date`
struct Index {
    let value: UInt64
        
    init(value: UInt64) {
        self.value = value
    }

    init(date: Date = .now) {
        self.init(value: UInt64(date.timeIntervalSinceReferenceDate * 1000))
    }
}
