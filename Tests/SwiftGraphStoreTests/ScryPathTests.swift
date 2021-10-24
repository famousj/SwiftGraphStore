import XCTest
import UrsusHTTP

@testable import SwiftGraphStore

final class ScryPathTests: XCTestCase {
    
    func test_asPath_keys() throws {
        let testObject = ScryPath.keys
        
        XCTAssertEqual(testObject.asPath, "/keys")
    }
    
    func test_asPath_graph() throws {
        let resource = Resource(ship: Ship("wet"), name: "test-resource")
        let testObject = ScryPath.graph(resource: resource)
        
        let expectedPath = "/graph/~wet/test-resource"
        XCTAssertEqual(testObject.asPath, expectedPath)
    }
    
    func test_asPath_rootNodes() throws {
        let resource = Resource(ship: Ship("nyt"), name: "graph-with-nodes")
        let testObject = ScryPath.rootNodes(resource: resource)
        
        let expectedPath = "/graph/~nyt/graph-with-nodes/subset/lone/~/~"
        XCTAssertEqual(testObject.asPath, expectedPath)
    }
}
