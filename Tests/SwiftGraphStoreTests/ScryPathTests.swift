import XCTest
import UrsusHTTP
import BigInt
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
    
    func test_asPath_node_singleIndex() throws {
        let resource = Resource(ship: Ship("nyt"), name: "graph-with-nodes")
        let index = Index(value: BigUInt(1234))
        let testObject = ScryPath.node(resource: resource, index: index)
        
        let expectedPath = "/graph/~nyt/graph-with-nodes/node/index/kith/1.234"
        XCTAssertEqual(testObject.asPath, expectedPath)
    }
    
    func test_asPath_node_multipleIndices() throws {
        let resource = Resource(ship: Ship("nyt"), name: "graph-with-nodes")
        let index = Index(values: [BigUInt(1), BigUInt(123456)])
        let testObject = ScryPath.node(resource: resource, index: index)

        let expectedPath = "/graph/~nyt/graph-with-nodes/node/index/kith/1/123.456"
        XCTAssertEqual(testObject.asPath, expectedPath)
    }
}
