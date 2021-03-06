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
        
        let expectedPath = "/graph/~nyt/graph-with-nodes/node/children/lone/~/~"
        XCTAssertEqual(testObject.asPath, expectedPath)
    }
    
    func test_asPath_node_singleIndex() throws {
        let resource = Resource(ship: Ship("nyt"), name: "graph-with-nodes")
        let index = Index(atoms: [Atom(1234)])
        let mode = ScryMode.includeDescendants
        let testObject = ScryPath.node(resource: resource,
                                       index: index,
                                       mode: mode)
        
        let expectedPath = "/graph/~nyt/graph-with-nodes/node/index/kith/1.234"
        XCTAssertEqual(testObject.asPath, expectedPath)
    }
    
    func test_asPath_node_multipleIndices() throws {
        let resource = Resource(ship: Ship("nyt"), name: "graph-with-nodes")
        let index = Index(atoms: [Atom(1), Atom(123456)])
        let mode = ScryMode.excludeDescendants
        let testObject = ScryPath.node(resource: resource,
                                       index: index,
                                       mode: mode)

        let expectedPath = "/graph/~nyt/graph-with-nodes/node/index/lone/1/123.456"
        XCTAssertEqual(testObject.asPath, expectedPath)
    }
}
