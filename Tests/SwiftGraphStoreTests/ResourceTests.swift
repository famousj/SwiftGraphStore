import XCTest
import UrsusHTTP

@testable import SwiftGraphStore

final class ResourceTests: XCTestCase {
    
    func test_id_combinesShipAndName() {
        let ship = Ship.random
        let name = UUID().uuidString
        let resource = Resource(ship: ship, name: name)

        let expectedValue = "\(ship)/\(name)"
        XCTAssertEqual(resource.id, expectedValue)
    }    
}
