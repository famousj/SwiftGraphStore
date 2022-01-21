import XCTest
@testable import SwiftGraphStore

class IndexTests: XCTestCase {
    func test_init_convertsDateUsingMilliseconds() {
        let milliseconds = Date.now.timeIntervalSinceReferenceDate * 1000
        
        let testObject = Index(date: Date.now)
        XCTAssertEqual(testObject.value, UInt64(milliseconds))
    }
}
