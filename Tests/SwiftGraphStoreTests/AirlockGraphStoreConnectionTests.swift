import XCTest
import Combine
import Alamofire
import UrsusHTTP

@testable import SwiftGraphStore

final class AirlockGraphStoreConnectionTests: XCTestCase {
    var cancellables = [AnyCancellable]()
    
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
    
    func test_requestLogin_setsLoggedInToTrue() throws {
        let expectedShip = Ship.random
        
        let fakeAirlockConnection = FakeAirlockConnection()
        fakeAirlockConnection.requestLogin_response = expectedShip
        
        let testObject = AirlockGraphStoreConnection(airlockConnection: fakeAirlockConnection)
        
        XCTAssertEqual(testObject.loggedIn, false)
        callRequestAndVerifyResponse(request: testObject.requestLogin,
                                     successClosure: { _ in
            XCTAssertEqual(testObject.loggedIn, true)
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
    
    func test_requestConnect_failsIfNotLoggedIn() throws {
        let fakeAirlockConnection = FakeAirlockConnection()
        
        let testObject = AirlockGraphStoreConnection(airlockConnection: fakeAirlockConnection)
        
        callRequestAndVerifyResponse(request: testObject.requestConnect,
                                     failureClosure: { error in
            XCTAssertEqual(error.isCreateURLRequestError, true)
        })
    }
    
    func test_requestConnect_pokesHelm() throws {
        let fakeAirlockConnection = FakeAirlockConnection()
        
        let testObject = AirlockGraphStoreConnection(airlockConnection: fakeAirlockConnection)
        
        let ship = Ship.random
        loginAndSetShip(testObject: testObject, fakeAirlockConnection: fakeAirlockConnection, ship: ship)
        
        callRequestAndVerifyResponse(request: testObject.requestConnect,
                                     completionClosure: { _ in
            XCTAssertEqual(fakeAirlockConnection.requestPoke_calledCount, 1)
            
            XCTAssertEqual(fakeAirlockConnection.requestPoke_paramShip, ship)
            XCTAssertEqual(fakeAirlockConnection.requestPoke_paramApp, "hood")
            XCTAssertEqual(fakeAirlockConnection.requestPoke_paramMark, "helm-hi")
            XCTAssertEqual(fakeAirlockConnection.requestPoke_paramJson, "iOS airlock connected")
        })
    }
    
    func test_requestConnect_whenPokeHelmSucceeds_callsConnect() throws {
        let fakeAirlockConnection = FakeAirlockConnection()
        
        let testObject = AirlockGraphStoreConnection(airlockConnection: fakeAirlockConnection)
        
        let ship = Ship.random
        loginAndSetShip(testObject: testObject, fakeAirlockConnection: fakeAirlockConnection, ship: ship)
        
        callRequestAndVerifyResponse(request: testObject.requestConnect,
                                     completionClosure: { _ in
            XCTAssertEqual(fakeAirlockConnection.connect_calledCount, 1)
        })
    }
    
    func test_requestConnect_whenPokeHelmFails_passesFailureAndDoesNotCallConnect() throws {
        let fakeAirlockConnection = FakeAirlockConnection()
        
        let testObject = AirlockGraphStoreConnection(airlockConnection: fakeAirlockConnection)
        
        let ship = Ship.random
        loginAndSetShip(testObject: testObject, fakeAirlockConnection: fakeAirlockConnection, ship: ship)
        
        let expectedError = AFError.sessionInvalidated(error: NSError())
        fakeAirlockConnection.requestPoke_error = expectedError
        
        callRequestAndVerifyResponse(request: testObject.requestConnect,
                                     failureClosure: { error in
            XCTAssertTrue(error.isSessionInvalidatedError)
            XCTAssertEqual(testObject.connected, false)
            XCTAssertEqual(fakeAirlockConnection.connect_calledCount, 0)
            
        })
    }
    
    func test_requestConnect_whenReceiveValue_setsConnectedStatus() throws {
        let fakeAirlockConnection = FakeAirlockConnection()
        
        let testObject = AirlockGraphStoreConnection(airlockConnection: fakeAirlockConnection)
        
        let ship = Ship.random
        loginAndSetShip(testObject: testObject, fakeAirlockConnection: fakeAirlockConnection, ship: ship)
        
        XCTAssertEqual(testObject.connected, false)
        callRequestAndVerifyResponse(request: testObject.requestConnect,
                                     successClosure: { value in
            XCTAssertEqual(testObject.connected, true)
        })
    }
    
    func test_requestConnect_whenConnectFails_passesFailure() throws {
        let fakeAirlockConnection = FakeAirlockConnection()
        
        let testObject = AirlockGraphStoreConnection(airlockConnection: fakeAirlockConnection)
        
        let ship = Ship.random
        loginAndSetShip(testObject: testObject, fakeAirlockConnection: fakeAirlockConnection, ship: ship)
        
        let expectedError = AFError.sessionTaskFailed(error: NSError())
        fakeAirlockConnection.connect_error = expectedError
        
        callRequestAndVerifyResponse(request: testObject.requestConnect,
                                     failureClosure: { error in
            XCTAssertTrue(error.isSessionTaskError)
            XCTAssertEqual(testObject.connected, false)
        })
    }
    
    private func callRequestAndVerifyResponse<T>(request: () -> AnyPublisher<T, AFError>,
                                                 successClosure: ((T) -> Void)? = nil,
                                                 failureClosure: ((AFError) -> Void)? = nil,
                                                 completionClosure: ((Subscribers.Completion<AFError>) -> Void)? = nil) {
        let expectation = XCTestExpectation(description: "Request completes")
        
        request()
            .sink(receiveCompletion: { completion in
                if let failureClosure = failureClosure {
                    if case let .failure(error) = completion {
                        failureClosure(error)
                    } else {
                        XCTFail("Expected failure and didn't get one!")
                    }
                }
                
                if let completionClosure = completionClosure {
                    completionClosure(completion)
                }
                expectation.fulfill()
            }, receiveValue: { (value: T) in
                if let successClosure = successClosure {
                    successClosure(value)
                }
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    private func loginAndSetShip(testObject: GraphStoreConnection,
                                 fakeAirlockConnection: FakeAirlockConnection,
                                 ship: Ship) {
        fakeAirlockConnection.requestLogin_response = ship
        let expectation = XCTestExpectation(description: "Fake logging in")
        var cancellables = [AnyCancellable]()
        
        testObject.requestLogin()
            .sink(receiveCompletion: { completion in
                expectation.fulfill()
            }, receiveValue: { _ in }
            )
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
}
