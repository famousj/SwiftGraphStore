import XCTest
import UrsusHTTP

@testable import SwiftGraphStore

final class UpdateDataTests: XCTestCase {
    func test_addGraphParses() {
        let _: GraphStoreUpdate = try! JSONLoader.load("add-graph.json")
    }
    
    func test_addGraphEncodeAndDecode() {
        let resource = Resource(ship: Ship.random, name: UUID().uuidString)
        let testObject = GraphUpdate.addGraph(resource: resource, graph: Graph(), mark: nil, overwrite: Bool.random())
        let encoder = JSONEncoder()
        let data = try! encoder.encode(testObject)
        
        let jsonString = String(data: data, encoding: .utf8)!
        print("JSON: \(jsonString)")
        
        let decoder = JSONDecoder()
        
        let decoded = try! decoder.decode(GraphUpdate.self, from: data)
        XCTAssertEqual(decoded, testObject)
    }
    
    func test_postParses() {
        let _: Post = try! JSONLoader.load("post.json")
    }

    func test_addNodesParses() {
        let _: GraphStoreUpdate = try! JSONLoader.load("add-nodes.json")
    }
    
    func test_addNodesEncodeAndDecode() {
        let resource = Resource(ship: Ship.random, name: UUID().uuidString)
        let testObject = GraphUpdate.addGraph(resource: resource, graph: Graph(), mark: nil, overwrite: Bool.random())
        let encoder = JSONEncoder()
        let data = try! encoder.encode(testObject)
        
        let jsonString = String(data: data, encoding: .utf8)!
        print("JSON: \(jsonString)")
        
        let decoder = JSONDecoder()
        
        let decoded = try! decoder.decode(GraphUpdate.self, from: data)
        XCTAssertEqual(decoded, testObject)
    }
}
