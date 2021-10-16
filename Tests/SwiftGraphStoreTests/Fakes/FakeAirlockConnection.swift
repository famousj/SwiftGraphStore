import Foundation
import Combine
import SwiftGraphStore
import Alamofire
import UrsusHTTP

class FakeAirlockConnection: AirlockConnection {
    var graphStoreSubscriptionSubject = PassthroughSubject<Data, SubscribeError>()
    var graphStoreSubscription: AnyPublisher<Data, SubscribeError> {
        graphStoreSubscriptionSubject
            .eraseToAnyPublisher()
    }
    
    var requestLogin_calledCount = 0
    var requestLogin_response: Ship?
    var requestLogin_error: AFError?
    func requestLogin() -> AnyPublisher<Ship, AFError> {
        requestLogin_calledCount += 1
        
        if let error = requestLogin_error {
            return Fail(outputType: Ship.self, failure: error)
                .eraseToAnyPublisher()
        } else {
            return Just(requestLogin_response!)
                .asAlamofirePublisher()
        }
    }
    
    var requestPoke_calledCount = 0
    var requestPoke_paramShip: Ship?
    var requestPoke_paramApp: App?
    var requestPoke_paramMark: Mark?
    var requestPoke_paramJson: Encodable?
    var requestPoke_error: PokeError?
    func requestPoke<T>(ship: Ship, app: App, mark: Mark, json: T) -> AnyPublisher<Never, PokeError> where T : Encodable {
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
    
    var requestScry_calledCount = 0
    var requestScry_paramApp: App?
    var requestScry_paramPath: Path?
    
    var requestScry_error: AFError?
    var requestScry_response: String?
    func requestScry(app: App, path: Path) -> AnyPublisher<String, AFError> {
        requestScry_calledCount += 1
        
        requestScry_paramApp = app
        requestScry_paramPath = path
        
        if let error = requestScry_error {
            return Fail(outputType: String.self, failure: error)
                .eraseToAnyPublisher()
        } else {
            return Just(requestScry_response!)
                .asAlamofirePublisher()
        }
    }
    
    var requestStartSubscription_calledCount = 0
    var requestStartSubscription_paramShip: Ship?
    var requestStartSubscription_paramApp: App?
    var requestStartSubscription_paramPath: Path?
    
    var requestStartSubscription_error: AFError?
    func requestStartSubscription(ship: Ship, app: App, path: Path) -> AnyPublisher<Never, AFError> {
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
    
    private func neverPublisher<E: Error>() -> AnyPublisher<Never, E> {
        Just(true)
            .ignoreOutput()
            .setFailureType(to: E.self)
            .eraseToAnyPublisher()
    }
}

extension Just {
    func asAlamofirePublisher<E: Error>() -> AnyPublisher<Output, E> {
        setFailureType(to: E.self)
            .eraseToAnyPublisher()
    }
}
