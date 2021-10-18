import XCTest
import Combine
import Alamofire
import UrsusHTTP

@testable import SwiftGraphStore

final class AirlockGraphStoreConnectionTests: XCTestCase {
    
    func test_createPost_whenNoShip_returnsNil() throws {
        let fakeAirlockConnection = FakeAirlockConnection()

        let testObject = AirlockGraphStoreConnection(airlockConnection: fakeAirlockConnection)
        
        XCTAssertNil(testObject.createPost(contents: nil))
    }
    
    func test_createPost_fillsInValues() throws {
        let fakeAirlockConnection = FakeAirlockConnection()

        let testObject = AirlockGraphStoreConnection(airlockConnection: fakeAirlockConnection)
        
        let ship = Ship.random
        testObject.setShip(ship)
        
        let contents = [Content(text: UUID().patUVString),
                        Content(text: UUID().uuidString)]
        let timeSent = Date()
        
        let post = testObject.createPost(contents: contents, timeSent: timeSent)
        
        guard let post = post else {
            XCTFail("Nil post!")
            return
        }
        
        XCTAssertEqual(post.author, ship)
        XCTAssertEqual(post.index, "/\(Int(timeSent.timeIntervalSince1970))")
        XCTAssertEqual(post.timeSent, timeSent)
        XCTAssertEqual(post.contents, contents)
        XCTAssertNil(post.hash)
        XCTAssertEqual(post.signatures, [])
    }

    func test_requestLogin_passesResultFromAirlock() throws {
        let expectedShip = try! Ship(string: "~wet")
        
        let fakeAirlockConnection = FakeAirlockConnection()
        fakeAirlockConnection.requestLogin_response = expectedShip
        
        let testObject = AirlockGraphStoreConnection(airlockConnection: fakeAirlockConnection)
        
        callRequestAndVerifyResponse(request: testObject.requestLogin,
                                     successClosure:  { ship in
            XCTAssertEqual(fakeAirlockConnection.requestLogin_calledCount, 1)
            XCTAssertEqual(ship, expectedShip)
        })
    }
    
    func test_requestLogin_storesTheReturnedShip() throws {
        let expectedShip = try! Ship(string: "~ribben-donnyl")
        
        let fakeAirlockConnection = FakeAirlockConnection()
        fakeAirlockConnection.requestLogin_response = expectedShip
        
        let testObject = AirlockGraphStoreConnection(airlockConnection: fakeAirlockConnection)
        
        callRequestAndVerifyResponse(request: testObject.requestLogin,
                                     successClosure: { _ in
            XCTAssertEqual(testObject.ship, expectedShip)
        })
    }
    
    func test_requestLogin_passesFailureFromAirlock() throws {
        let requestError = AFError.createURLRequestFailed(error: NSError(domain: "", code: 42))
        
        let fakeAirlockConnection = FakeAirlockConnection()
        fakeAirlockConnection.requestLogin_error = requestError
        
        let testObject = AirlockGraphStoreConnection(airlockConnection: fakeAirlockConnection)
        
        callRequestAndVerifyResponse(request: testObject.requestLogin,
                                     failureClosure: { error in
            XCTAssert(error.isCreateURLRequestError)
        })
    }
    
    func test_requestConnect_failsIfNoShip() throws {
        let fakeAirlockConnection = FakeAirlockConnection()
        
        let testObject = AirlockGraphStoreConnection(airlockConnection: fakeAirlockConnection)

        callRequestAndVerifyResponse(request: testObject.requestConnect,
                                     failureClosure: { error in
            XCTAssert(error.errorDescription!.starts(with: "Poke failure"))
        })
    }
    
    func test_requestConnect_pokesHelm() throws {
        let fakeAirlockConnection = FakeAirlockConnection()
        
        let testObject = AirlockGraphStoreConnection(airlockConnection: fakeAirlockConnection)

        let ship = Ship.random
        testObject.setShip(ship)
        
        callRequestAndVerifyResponse(request: testObject.requestConnect,
                                     completionClosure: { _ in
            XCTAssertEqual(fakeAirlockConnection.requestPoke_calledCount, 1)
            
            XCTAssertEqual(fakeAirlockConnection.requestPoke_paramShip, ship)
            XCTAssertEqual(fakeAirlockConnection.requestPoke_paramApp, "hood")
            XCTAssertEqual(fakeAirlockConnection.requestPoke_paramMark, "helm-hi")
            XCTAssertEqual(fakeAirlockConnection.requestPoke_paramJson as? String, "airlock connected")
        })
    }
    
    func test_requestConnect_whenPokeHelmFails_passesFailure() throws {
        let fakeAirlockConnection = FakeAirlockConnection()
        
        let testObject = AirlockGraphStoreConnection(airlockConnection: fakeAirlockConnection)

        let ship = Ship.random
        testObject.setShip(ship)

        let errorID = UUID().uuidString
        let expectedError = PokeError.pokeFailure(errorID)
        fakeAirlockConnection.requestPoke_error = expectedError
        
        callRequestAndVerifyResponse(request: testObject.requestConnect,
                                     failureClosure: { error in
            XCTAssertEqual(error.errorDescription, "Poke failure: \(errorID)")
        })
    }
    
    func test_requestStartSubscription_failsIfNoShip() {
        let fakeAirlockConnection = FakeAirlockConnection()
        
        let testObject = AirlockGraphStoreConnection(airlockConnection: fakeAirlockConnection)

        callRequestAndVerifyResponse(request: testObject.requestConnect,
                                     failureClosure: { error in
            XCTAssert(error.errorDescription!.starts(with: "Poke failure"))
        })
    }
    
    func test_requestStartSubscription_callsStartSubscriptionOnAirlock() throws {
        let fakeAirlockConnection = FakeAirlockConnection()
        
        let testObject = AirlockGraphStoreConnection(airlockConnection: fakeAirlockConnection)

        let ship = Ship.random
        testObject.setShip(ship)

        callRequestAndVerifyResponse(request: testObject.requestStartSubscription,
                                     completionClosure: { _ in
            XCTAssertEqual(fakeAirlockConnection.requestStartSubscription_calledCount, 1)
            
            XCTAssertEqual(fakeAirlockConnection.requestStartSubscription_paramShip, ship)
            XCTAssertEqual(fakeAirlockConnection.requestStartSubscription_paramApp, Constants.graphStoreAppName)
            XCTAssertEqual(fakeAirlockConnection.requestStartSubscription_paramPath, Constants.graphStoreUpdatePath)
        })
    }
    
    func test_requestStartSubscription_whenAirlockFails_passesFailure() throws {
        let fakeAirlockConnection = FakeAirlockConnection()
        
        let testObject = AirlockGraphStoreConnection(airlockConnection: fakeAirlockConnection)

        let ship = Ship.random
        testObject.setShip(ship)

        fakeAirlockConnection.requestStartSubscription_error = AFError.sessionTaskFailed(error: NSError())
        
        callRequestAndVerifyResponse(request: testObject.requestStartSubscription,
                                     failureClosure: { error in
            XCTAssert(error.isSessionTaskError)
        })
    }
        
    func test_requestAddGraph_failsIfNoShip() throws {
        let fakeAirlockConnection = FakeAirlockConnection()
        
        let testObject = AirlockGraphStoreConnection(airlockConnection: fakeAirlockConnection)

        let request: () -> AnyPublisher<Never, PokeError> = { testObject.requestAddGraph(name: "") }
        callRequestAndVerifyResponse(request: request,
                                     failureClosure: { error in
            XCTAssert(error.errorDescription!.starts(with: "Poke failure"))
        })
    }

    func test_requestAddGraph_pokesGraphStore() throws {
        let fakeAirlockConnection = FakeAirlockConnection()
        
        let testObject = AirlockGraphStoreConnection(airlockConnection: fakeAirlockConnection)

        let ship = Ship.random
        testObject.setShip(ship)

        let name = UUID().uuidString
        let resource = Resource(ship: ship, name: name)
        let update = GraphUpdate.addGraph(resource: resource, graph: Graph(), mark: nil, overwrite: true)
        
        let request: () -> AnyPublisher<Never, PokeError> = { testObject.requestAddGraph(name: name) }
        callRequestAndVerifyResponse(request: request,
                                     completionClosure: { _ in
            XCTAssertEqual(fakeAirlockConnection.requestPoke_calledCount, 1)
            
            XCTAssertEqual(fakeAirlockConnection.requestPoke_paramShip, ship)
            XCTAssertEqual(fakeAirlockConnection.requestPoke_paramApp, Constants.graphStoreAppName)
            XCTAssertEqual(fakeAirlockConnection.requestPoke_paramMark, Constants.graphStoreUpdateMark)
            XCTAssertEqual(fakeAirlockConnection.requestPoke_paramJson as? GraphUpdate, update)

        })
    }
    
    func test_requestAddGraph_whenAirlockFails_passesAlongTheFailure() throws {
        let fakeAirlockConnection = FakeAirlockConnection()
        
        let testObject = AirlockGraphStoreConnection(airlockConnection: fakeAirlockConnection)

        let ship = Ship.random
        testObject.setShip(ship)

        let errorID = UUID().uuidString
        let expectedError = PokeError.pokeFailure(errorID)
        fakeAirlockConnection.requestPoke_error = expectedError
        
        let request: () -> AnyPublisher<Never, PokeError> = { testObject.requestAddGraph(name: "") }
        callRequestAndVerifyResponse(request: request,
                                     failureClosure: { error in
            XCTAssertEqual(error.errorDescription, "Poke failure: \(errorID)")
        })
    }
    
    func test_requestAddNodes_failsIfNoShip() throws {
        let fakeAirlockConnection = FakeAirlockConnection()
        
        let testObject = AirlockGraphStoreConnection(airlockConnection: fakeAirlockConnection)
                
        let post = Post(author: Ship.random,
                        index: "",
                        timeSent: Date(),
                        contents: nil,
                        hash: nil,
                        signatures: [])

        let request: () -> AnyPublisher<Never, PokeError> = { testObject.requestAddNodes(name: "", post: post) }
        callRequestAndVerifyResponse(request: request,
                                     failureClosure: { error in
            XCTAssert(error.errorDescription!.starts(with: "Poke failure"))
        })
    }

    func test_requestAddNodes_pokesGraphStore() throws {
        let fakeAirlockConnection = FakeAirlockConnection()
        
        let testObject = AirlockGraphStoreConnection(airlockConnection: fakeAirlockConnection)

        let ship = Ship.random
        testObject.setShip(ship)
        
        let name = UUID().uuidString
        let resource = Resource(ship: ship, name: name)
        
        let post = testObject.createPost(contents: nil)!
        let index = post.index
        
        let updateNodes = [index: UpdateNode(post: post, children: nil)]
        
        let update = GraphUpdate.addNodes(resource: resource, nodes: updateNodes)

        let request: () -> AnyPublisher<Never, PokeError> = { testObject.requestAddNodes(name: name, post: post) }
        callRequestAndVerifyResponse(request: request,
                                     completionClosure: { _ in
            XCTAssertEqual(fakeAirlockConnection.requestPoke_calledCount, 1)
            
            XCTAssertEqual(fakeAirlockConnection.requestPoke_paramShip, ship)
            XCTAssertEqual(fakeAirlockConnection.requestPoke_paramApp, Constants.graphStoreAppName)
            XCTAssertEqual(fakeAirlockConnection.requestPoke_paramMark, Constants.graphStoreUpdateMark)
            XCTAssertEqual(fakeAirlockConnection.requestPoke_paramJson as? GraphUpdate, update)

        })
    }
    
    func test_requestAddNodes_whenAirlockFails_passesAlongTheFailure() throws {
        let fakeAirlockConnection = FakeAirlockConnection()
        
        let testObject = AirlockGraphStoreConnection(airlockConnection: fakeAirlockConnection)

        testObject.setShip(Ship.random)

        let name = UUID().patUVString
        let post = testObject.createPost(contents: nil)!

        let errorID = UUID().uuidString
        let expectedError = PokeError.pokeFailure(errorID)
        fakeAirlockConnection.requestPoke_error = expectedError
        
        let request: () -> AnyPublisher<Never, PokeError> = { testObject.requestAddNodes(name: name, post: post) }
        callRequestAndVerifyResponse(request: request,
                                     failureClosure: { error in
            XCTAssertEqual(error.errorDescription, "Poke failure: \(errorID)")
        })
    }

    func test_graphStoreSubscription_convertsDataToUpdate() {
        let fakeAirlockConnection = FakeAirlockConnection()
        
        let testObject = AirlockGraphStoreConnection(airlockConnection: fakeAirlockConnection)

        let ship = Ship.random
        testObject.setShip(ship)

        let resource = Resource(ship: ship, name: UUID().uuidString)
        let graphUpdate = GraphUpdate.addGraph(resource: resource, graph: Graph(), mark: UUID().uuidString, overwrite: Bool.random())
        let expectedUpdate = GraphStoreUpdate(graphUpdate: graphUpdate)
        
        var cancellables = [AnyCancellable]()
        let expectation = XCTestExpectation(description: "Data converted")
        testObject
            .graphStoreSubscription
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { value in
                    XCTAssertEqual(value, expectedUpdate)
                    expectation.fulfill()
                }
            )
            .store(in: &cancellables)
                
        let encoder = JSONEncoder()
        let updateData = try! encoder.encode(expectedUpdate)
        fakeAirlockConnection
            .graphStoreSubscriptionSubject
            .send(updateData)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_graphStoreSubscription_sendsErrorForBadData() {
        let fakeAirlockConnection = FakeAirlockConnection()
        
        let testObject = AirlockGraphStoreConnection(airlockConnection: fakeAirlockConnection)
        
        var cancellables = [AnyCancellable]()
        let expectation = XCTestExpectation(description: "Error sent")
        testObject
            .graphStoreSubscription
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    XCTAssertNotNil(error as? DecodingError)
                    expectation.fulfill()
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
                
        let badData = """
                { "graph-update": {}}
                """.data(using: .utf8)!
        fakeAirlockConnection
            .graphStoreSubscriptionSubject
            .send(badData)
        
        wait(for: [expectation], timeout: 1)
    }
    
    private func callRequestAndVerifyResponse<T, E: Error>(request: () -> AnyPublisher<T, E>,
                                                 successClosure: ((T) -> Void)? = nil,
                                                 failureClosure: ((E) -> Void)? = nil,
                                                 completionClosure: ((Subscribers.Completion<E>) -> Void)? = nil) {
        var cancellables = [AnyCancellable]()

        let expectation = XCTestExpectation(description: "Request completes")
        
        request()
            .sink(receiveCompletion: { completion in
                if let failureClosure = failureClosure {
                    if case let .failure(error) = completion {
                        failureClosure(error)
                    } else {
                        XCTFail("Expected failure and didn't get one!")
                    }
                    expectation.fulfill()
                }
                
                if let completionClosure = completionClosure {
                    completionClosure(completion)
                    expectation.fulfill()
                }
            }, receiveValue: { (value: T) in
                if let successClosure = successClosure {
                    successClosure(value)
                    expectation.fulfill()
                }
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
}

fileprivate extension AirlockGraphStoreConnection {
    func setShip(_ ship: Ship) {
        self.ship = ship
    }
}
