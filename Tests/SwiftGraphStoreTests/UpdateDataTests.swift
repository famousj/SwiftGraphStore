import XCTest
import UrsusHTTP
import SwiftGraphStoreFakes

@testable import SwiftGraphStore

// TODO: Fill in all the nil values with real values and make sure things still work
final class UpdateDataTests: XCTestCase {
    
    func test_addGraph_pokeResponseParses() throws {
        let _: GraphStoreUpdate = try JSONLoader.load("add-graph-poke.json")
    }
    
    func test_addGraph_scryResponseParses() throws {
        let update: GraphStoreUpdate = try JSONLoader.load("add-graph-scry.json")

        guard case let .addGraph(_, graphDict, _, _) = update.graphUpdate else {
            XCTFail("Didn't decode as a .addGraph!")
            return
        }
        
        let atom = Atom(100)
        let grandchildren = try XCTUnwrap(graphDict[atom]?.children?[atom]?.children)
        XCTAssertEqual(grandchildren.keys.count, 1)
        XCTAssertEqual(grandchildren.keys.first, atom)
    }
    
    func test_postParses() throws {
        let _: Post = try JSONLoader.load("post.json")
    }
    
    func test_nodeParses() throws {
        let node: Node = try JSONLoader.load("node.json")
        
        XCTAssertNotNil(node.children)
    }
    
    func test_graphEncodeAndDecode() throws {
        let grandchildren = Graph.testInstance
        let children = [Atom.testInstance: Node(post: Post.testInstance, children: grandchildren),
                        Atom.testInstance: Node(post: Post.testInstance, children: nil)]

        let post = Post.testInstance
        let testObject = Node(post: post, children: children)
        
        let data = try XCTUnwrap(try? JSONEncoder().encode(testObject))

        
        let decoded = try JSONDecoder().decode(Node.self, from: data)
        XCTAssertEqual(decoded, testObject)
    }

    func test_addNodesParses() throws {
        let _: GraphStoreUpdate = try JSONLoader.load("add-nodes.json")
    }
    
    func test_keysPares() throws {
        let _: GraphStoreUpdate = try JSONLoader.load("keys.json")
    }

    func test_addGraphEncodeAndDecode() throws {
        let resource = Resource.testInstance
        let graph = Graph.testInstance
        let testObject = GraphUpdate.addGraph(resource: resource,
                                              graph: graph,
                                              mark: nil,
                                              overwrite: Bool.random())
        let encoder = JSONEncoder()
        let data = try! encoder.encode(testObject)
        
        let jsonString = String(data: data, encoding: .utf8)!
        print("JSON: \(jsonString)")
        
        let decoded = try JSONDecoder()
            .decode(GraphUpdate.self, from: data)
        XCTAssertEqual(decoded, testObject)
    }
        
    func test_addNodesEncodeAndDecode() throws {
        let children = Graph.testInstance

        let resource = Resource.testInstance
        let index = Index.testInstance
        let post = Post.testInstance
        let graph = Node(post: post, children: children)
        
        let testObject = GraphUpdate.addNodes(resource: resource,
                                              nodes: [index: graph])
        
        let encoder = JSONEncoder()
        let data = try! encoder.encode(testObject)
        
        let jsonString = String(data: data, encoding: .utf8)!
        print("JSON: \(jsonString)")
        
        let decoder = JSONDecoder()
        
        let decoded = try decoder.decode(GraphUpdate.self, from: data)
        XCTAssertEqual(decoded, testObject)
    }
    
    func test_addKeysEncodeAndDecode() {
        let keys = [ Resource.testInstance, Resource.testInstance ]
        let testObject = GraphUpdate.keys(keys)
        
        let encoder = JSONEncoder()
        let data = try! encoder.encode(testObject)
        
        let jsonString = String(data: data, encoding: .utf8)!
        print("JSON: \(jsonString)")
        
        let decoder = JSONDecoder()
        
        let decoded = try! decoder.decode(GraphUpdate.self, from: data)
        XCTAssertEqual(decoded, testObject)
    }
}
