import Foundation
import Combine
import SwiftGraphStore
import Alamofire
import UrsusHTTP

public class FakeAirlockConnection: AirlockConnecting {
    
    public init() {}
    
    public var graphStoreSubscriptionSubject = PassthroughSubject<Data, SubscribeError>()
    public var graphStoreSubscription: AnyPublisher<Data, SubscribeError> {
        graphStoreSubscriptionSubject
            .eraseToAnyPublisher()
    }
    
    public var requestLogin_calledCount = 0
    public var requestLogin_response: Ship?
    public var requestLogin_error: AFError?
    public func requestLogin() -> AnyPublisher<Ship, AFError> {
        requestLogin_calledCount += 1
        
        if let error = requestLogin_error {
            return Fail(outputType: Ship.self, failure: error)
                .eraseToAnyPublisher()
        } else {
            return Just(requestLogin_response ?? Ship.random)
                .withErrorType()
        }
    }
    
    public var requestPoke_calledCount = 0
    public var requestPoke_paramShip: Ship?
    public var requestPoke_paramApp: App?
    public var requestPoke_paramMark: Mark?
    public var requestPoke_paramJson: Encodable?
    public var requestPoke_error: PokeError?
    public func requestPoke<T: Encodable>(ship: Ship, app: App, mark: Mark, json: T) -> AnyPublisher<Never, PokeError> {
        requestPoke_calledCount += 1
        requestPoke_paramShip = ship
        requestPoke_paramApp = app
        requestPoke_paramMark = mark
        requestPoke_paramJson = json
        
        if let error = requestPoke_error {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
        else {
            return neverPublisher()
        }
    }
    
    public var requestScry_calledCount = 0
    public var requestScry_paramApp: App?
    public var requestScry_paramPath: Path?
    public var requestScry_error: AFError?
    public var requestScry_response: Decodable?
    public func requestScry<T: Decodable>(app: App, path: Path) -> AnyPublisher<T, AFError> {
        requestScry_calledCount += 1
        
        requestScry_paramApp = app
        requestScry_paramPath = path
        
        if let error = requestScry_error {
            return Fail(outputType: T.self, failure: error)
                .eraseToAnyPublisher()
        } else {
            return Just(requestScry_response! as! T)
                .withErrorType()
        }
    }
    
    public var requestStartSubscription_calledCount = 0
    public var requestStartSubscription_paramShip: Ship?
    public var requestStartSubscription_paramApp: App?
    public var requestStartSubscription_paramPath: Path?
    public var requestStartSubscription_error: AFError?
    public func requestStartSubscription(ship: Ship, app: App, path: Path) -> AnyPublisher<Never, AFError> {
        requestStartSubscription_calledCount += 1
        
        requestStartSubscription_paramShip = ship
        requestStartSubscription_paramApp = app
        requestStartSubscription_paramPath = path
        
        if let error = requestStartSubscription_error {
            return Fail(error: error)
                .eraseToAnyPublisher()
        } else {
            return neverPublisher()
        }
    }
    
    public func requestTestScry(app: App, path: Path) -> AnyPublisher<String, AFError> {
        Fail(error: AFError.responseValidationFailed(reason: .dataFileNil))
            .eraseToAnyPublisher()
    }
}
