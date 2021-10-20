import XCTest
import UrsusHTTP

@testable import SwiftGraphStore

final class GraphUpdateTests: XCTestCase {
    
    func test_id_addGraph_usesResource() {
        let resource = Resource(ship: Ship.random, name: UUID().uuidString)
        
        let testObject = GraphUpdate.addGraph(resource: resource, graph: Graph(), mark: nil, overwrite: false)
        
        XCTAssertEqual(testObject.id, resource.id)
    }
    
    func test_id_addNodes_usesResource() {
        let resource = Resource(ship: Ship.random, name: UUID().uuidString)
        
        let testObject = GraphUpdate.addNodes(resource: resource, nodes: [:])
        
        XCTAssertEqual(testObject.id, resource.id)
    }
}
