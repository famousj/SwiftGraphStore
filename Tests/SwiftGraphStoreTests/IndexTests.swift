import XCTest
@testable import SwiftGraphStore

class IndexTests: XCTestCase {
    func test_init_convertsDateUsingMilliseconds() {
        let milliseconds = Date.now.timeIntervalSinceReferenceDate * 1000
        
        let testObject = Index(date: Date.now)
        XCTAssertEqual(testObject.atoms, [Atom(milliseconds)])
    }
    
    func test_init_handlesVeryLargeNumbers() {
        let testObject = Index("170141184505301775679338763611805088481")
        XCTAssertEqual(testObject?.path, "/170141184505301775679338763611805088481")
    }
    
    func test_init_acceptsFormattedString() throws {
        let indexString = "123.456.789"
        let testObject = try XCTUnwrap(Index(indexString))

        XCTAssertEqual(testObject.pathWithSeparators, "/\(indexString)")
    }
    
    func test_init_acceptsPath() throws {
        let indexString = "/123/456/789"
        let testObject = try XCTUnwrap(Index(indexString))
        
        let expectedValues = [Atom(123), Atom(456), Atom(789)]
        XCTAssertEqual(testObject.atoms, expectedValues)
    }
    
    func test_init_whenStringHasInvalidCharacters_returnsNil() throws {
        let indexString = "1.234,56"
       XCTAssertNil(Index(indexString))
    }
    
    func test_init_whenStringIsPathWithInvalidCharcters_returnsNil() throws {
        let indexString = "/123/invalid"
       XCTAssertNil(Index(indexString))
    }
    
    func test_init_ignoresFas() throws {
        let indexString = "/12345"

        let testObject = try XCTUnwrap(Index(indexString))
        
        XCTAssertEqual(testObject.path, indexString)
        let expectedValues = [Atom(12345)]
        XCTAssertEqual(testObject.atoms, expectedValues)
    }
    
    func test_path_formatsCorrectly() {
        let testObject = Index(atoms: [Atom(123456789)])
        
        let expectedString = "/123456789"
        XCTAssertEqual(testObject.path, expectedString)
    }
    
    func test_path_handlesMultipleValues() {
        let atoms = [Atom(123), Atom(456)]
        let testObject = Index(atoms: atoms)
        
        let expectedString = "/123/456"
        XCTAssertEqual(testObject.path, expectedString)
    }
    
    func test_pathWithSeparators_formatsCorrectly() {
        let testObject = Index("123456789")!
        
        let expectedString = "/123.456.789"
        XCTAssertEqual(testObject.pathWithSeparators, expectedString)
    }
    
    func test_pathWithSeparators_handlesMultipleValues() {
        let atoms = [Atom("123456789"), Atom("987654321")]
        let testObject = Index(atoms: atoms)
        
        let expectedString = "/123.456.789/987.654.321"
        XCTAssertEqual(testObject.pathWithSeparators, expectedString)
    }
    
    func test_pathWithSeparators_handlesShortNumbers() {
        let testObject = Index("12")!
        
        let expectedString = "/12"
        XCTAssertEqual(testObject.pathWithSeparators, expectedString)
    }
    
    func test_pathWithSeparators_usesGroupsOfThree() throws {
        let indexString = "1.234"
        let testObject = try XCTUnwrap(Index(indexString))

        let expectedString = "/1.234"
        XCTAssertEqual(testObject.pathWithSeparators, expectedString)
    }
    
    func test_rawRepresentable_createsPathString() throws {
        let atoms = [Atom(123), Atom(456), Atom(789)]
        let testObject = Index(atoms: atoms)
        
        let expectedString = "/123/456/789"
        XCTAssertEqual(testObject.rawValue, expectedString)
    }
    
    func test_encodable() throws {
        let expectedJsonString = """
        "\\/12345"
        """
        
        let testObject = Index("12345")!
        let json = try JSONEncoder().encode(testObject)
        let jsonString = String(data: json, encoding: .utf8)
        
        XCTAssertEqual(jsonString, expectedJsonString)
    }
    
    func test_decodable() throws {
        let jsonString = "\"/12345\""

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
        let indexString = "/1234"
        let dict = [Index(indexString)!: 1234]
        
        let expectedDict = [indexString: 1234]
        let stringDict = Index.convertIndexDictionary(dict)
        XCTAssertEqual(stringDict, expectedDict)
    }
    
    func test_lessThan_whenLessThan_returnsFalse() {
        let lhsValues = [Atom(1), Atom(2), Atom(3)]
        let rhsValues = [Atom(1), Atom(3), Atom(3)]
        
        let lhs = Index(atoms: lhsValues)
        let rhs = Index(atoms: rhsValues)

        XCTAssertEqual(lhs < rhs, true)
    }
    
    func test_lessThan_whenEqual_returnsFalse() {
        let lhsValues = [Atom(1), Atom(2), Atom(3)]
        let rhsValues = [Atom(1), Atom(2), Atom(3)]
        
        let lhs = Index(atoms: lhsValues)
        let rhs = Index(atoms: rhsValues)

        XCTAssertEqual(lhs < rhs, false)
    }
    
    func test_lessThan_whenGreaterThan_returnsFalse() {
        let lhsValues = [Atom(1), Atom(2), Atom(6)]
        let rhsValues = [Atom(1), Atom(2), Atom(3)]
        
        let lhs = Index(atoms: lhsValues)
        let rhs = Index(atoms: rhsValues)

        XCTAssertEqual(lhs < rhs, false)
    }
    

}
