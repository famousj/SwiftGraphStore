import XCTest

@testable import SwiftGraphStore

final class UpdateDataTests: XCTestCase {
    func test_addGraphParses() {
        let _: AddGraphUpdate = try! JSONLoader.load("add-graph.json")
    }
    
    func test_graphUpdateParses() {
        let _: GraphUpdate = try! JSONLoader.load("graph-update.json")
    }
    
    func test_updateParses() {
        let _: GraphStoreUpdate = try! JSONLoader.load("subscription-update.json")
    }
}
