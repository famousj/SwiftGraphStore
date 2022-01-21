import XCTest
import BigInt
@testable import SwiftGraphStore

class IndexTests: XCTestCase {
    func test_init_convertsDateUsingMilliseconds() {
        let milliseconds = Date.now.timeIntervalSinceReferenceDate * 1000
        
        let testObject = Index(date: Date.now)
        XCTAssertEqual(testObject.value, BigUInt(milliseconds))
    }
    
    func test_init_handlesVeryLargeNumbers() {
        let testObject = Index("170141184505301775679338763611805088481")
        XCTAssertEqual(testObject?.string, "170141184505301775679338763611805088481")
    }
    
    func test_string_formatsCorrectly() {
        let testObject = Index("123456789")!
        
        let expectedString = "123456789"
        XCTAssertEqual(testObject.string, expectedString)
    }
    
    func test_stringWithSeparators_formatsCorrectly() {
        let testObject = Index("123456789")!
        
        let expectedString = "123.456.789"
        XCTAssertEqual(testObject.stringWithSeparators, expectedString)
    }
    
    func test_stringWithSeparators_handlesShortNumbers() {
        let testObject = Index("12")!
        
        let expectedString = "12"
        XCTAssertEqual(testObject.stringWithSeparators, expectedString)
    }
    
    func test_init_acceptsFormattedString() throws {
        let indexString = "123.456.789"
        let testObject = try XCTUnwrap(Index(indexString))

        XCTAssertEqual(testObject.stringWithSeparators, indexString)
    }
    
    func test_init_whenStringHasInvalidCharacters_returnsNil() throws {
        let indexString = "1.234,56"
       XCTAssertNil(Index(indexString))
    }
    
    func test_init_usesGroupsOfThree() throws {
        let indexString = "1.234"
        let testObject = try XCTUnwrap(Index(indexString))

        let expectedString = "1.234"
        XCTAssertEqual(testObject.stringWithSeparators, expectedString)
    }
    
    func test_init_ignoresFas() throws {
        let indexString = "/12345"

        let testObject = try XCTUnwrap(Index(indexString))
        
        let expectedString = "12345"
        XCTAssertEqual(testObject.string, expectedString)
    }
    
    func test_encodable() throws {
        let expectedJsonString = "\"12345\""
        
        let testObject = Index("12345")!
        let json = try JSONEncoder().encode(testObject)
        let jsonString = String(data: json, encoding: .utf8)
        
        XCTAssertEqual(jsonString, expectedJsonString)
    }
    
    func test_decodable() throws {
        let jsonString = "\"12345\""

        let json = jsonString.data(using: .utf8)!
        let index = try JSONDecoder().decode(Index.self, from: json)
        
        let expectedIndex = Index("12345")
        XCTAssertEqual(index, expectedIndex)
    }
    
    func test_decode_ignoresFas() throws {
        let jsonString = "\"/12345\""

        let json = jsonString.data(using: .utf8)!
        let index = try JSONDecoder().decode(Index.self, from: json)
        
        let expectedIndex = Index("12345")
        XCTAssertEqual(index, expectedIndex)
    }
    
    func test_convertStringDictionary_succeeds() throws {
        let indexString = "1234"
        let dict = [indexString: 1234]
        
        let expectedDict = [Index(indexString)!: 1234]
        let indexDict = try Index.convertStringDictionary(dict)
        XCTAssertEqual(indexDict, expectedDict)
    }

    func test_convertIndexDictionary_succeeds() {
        let indexString = "1234"
        let dict = [Index(indexString)!: 1234]
        
        let expectedDict = [indexString: 1234]
        let stringDict = Index.convertIndexDictionary(dict)
        XCTAssertEqual(stringDict, expectedDict)
    }
}
