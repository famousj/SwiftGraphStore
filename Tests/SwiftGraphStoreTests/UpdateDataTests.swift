import XCTest
import UrsusHTTP

@testable import SwiftGraphStore

// TODO: Fill in all the nil values with real values and make sure things still work
final class UpdateDataTests: XCTestCase {
    func test_addGraph_pokeResponseParses() {
        let _: GraphStoreUpdate = try! JSONLoader.load("add-graph-poke.json")
    }
    
    func test_addGraph_scryResponseParses() {
        let _: GraphStoreUpdate = try! JSONLoader.load("add-graph-scry.json")
    }

    func test_addGraphEncodeAndDecode() {
        let resource = Resource(ship: Ship.random, name: UUID().uuidString)
        let post = Post(author: resource.ship,
                        index: UUID().uuidString,
                        timeSent: Date(),
                        contents: nil,
                        hash: nil,
                        signatures: [])
        let graph = Graph(post: post, children: nil)
        let index = post.index
        let testObject = GraphUpdate.addGraph(resource: resource,
                                              graph: [index:graph],
                                              mark: nil,
                                              overwrite: Bool.random())
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
        let post = Post(author: resource.ship,
                        index: UUID().uuidString,
                        timeSent: Date(),
                        contents: nil,
                        hash: nil,
                        signatures: [])
        let graph = Graph(post: post, children: nil)
        let index = post.index
        let testObject = GraphUpdate.addNodes(resource: resource,
                                              nodes: [index: graph])
        
        let encoder = JSONEncoder()
        let data = try! encoder.encode(testObject)
        
        let jsonString = String(data: data, encoding: .utf8)!
        print("JSON: \(jsonString)")
        
        let decoder = JSONDecoder()
        
        let decoded = try! decoder.decode(GraphUpdate.self, from: data)
        XCTAssertEqual(decoded, testObject)
    }
}
