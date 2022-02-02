import XCTest
@testable import SwiftGraphStore

class GraphTests: XCTestCase {
    func test_asStringDictionary_converts() {
        let keys: [Atom] = [1, 2, 3]
        let values = [Node(post: Post.testInstance, children: nil),
                    Node(post: Post.testInstance, children: nil),
                    Node(post: Post.testInstance, children: nil)]
        let graph = Graph(uniqueKeysWithValues: zip(keys, values))
        
        let expectedKeys = ["1", "2", "3"]
        let expectedDict = Dictionary(uniqueKeysWithValues: zip(expectedKeys, values))
        
        XCTAssertEqual(graph.asStringDictionary(), expectedDict)
    }
    
    func test_asGraph_converts() {
        let keys = ["1", "2", "3"]
        let values = [Node(post: Post.testInstance, children: nil),
                    Node(post: Post.testInstance, children: nil),
                    Node(post: Post.testInstance, children: nil)]
        let dictionary = Dictionary(uniqueKeysWithValues: zip(keys, values))
        
        let expectedKeys: [Atom] = [1, 2, 3]
        let expectedDict = Graph(uniqueKeysWithValues: zip(expectedKeys, values))
        XCTAssertEqual(try? dictionary.asGraph(), expectedDict)
    }
    
    func test_asGraph_whenBadValue_throws() {
        let keys = ["Not an atom"]
        let values = [Node(post: Post.testInstance, children: nil)]
        let dictionary = Dictionary(uniqueKeysWithValues: zip(keys, values))
        
        XCTAssertThrowsError(try dictionary.asGraph())
    }
}
