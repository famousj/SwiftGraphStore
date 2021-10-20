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
    
    func test_id_addNodes_usesResource() {
        let resource = Resource(ship: Ship.random, name: UUID().uuidString)
        
        let testObject = GraphUpdate.addNodes(resource: resource, nodes: [:])
        
        XCTAssertEqual(testObject.id, resource.id)
    }
}
