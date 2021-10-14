import XCTest

@testable import SwiftGraphStore

final class UpdateDataTests: XCTestCase {
    func test_addGraphParses() {
        let _: AddGraph = try! JSONLoader.load("add-graph.json")
    }
    
    func test_graphUpdateParses() {
        let _: GraphUpdate = try! JSONLoader.load("graph-update.json")
    }
    
    func test_subscriptionUpdateParses() {
        let _: GraphStoreSubscriptionUpdate = try! JSONLoader.load("subscription-update.json")
    }
}
