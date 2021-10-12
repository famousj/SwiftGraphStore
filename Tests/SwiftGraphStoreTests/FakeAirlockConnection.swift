import Foundation
import Combine
import SwiftGraphStore
import Alamofire
import UrsusHTTP

class FakeAirlockConnection: AirlockConnection {
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
                .asAlamofirePublisher
        }
    }
    
    var requestPoke_calledCount = 0
    var requestPoke_paramShip: Ship?
    var requestPoke_paramApp: App?
    var requestPoke_paramMark: Mark?
    var requestPoke_paramJson: String?
    var requestPoke_error: AFError?
    func requestPoke<T: Encodable>(ship: Ship, app: App, mark: Mark, json: T, handler: @escaping (PokeEvent) -> Void) -> AnyPublisher<Alamofire.Empty, AFError> {
        requestPoke_calledCount += 1
        requestPoke_paramShip = ship
        requestPoke_paramApp = app
        requestPoke_paramMark = mark
        requestPoke_paramJson = json as? String
        
        if let error = requestPoke_error {
            return Fail(outputType: Empty.self, failure: error)
                .eraseToAnyPublisher()
        } else {
            return Just(Alamofire.Empty.emptyValue())
                .asAlamofirePublisher
        }
    }
    
    var connect_calledCount = 0
    var connect_error: AFError?
    func connect() -> AnyPublisher<String, AFError> {
        connect_calledCount += 1
        
        if let error = connect_error {
            return Fail(error: error)
                .eraseToAnyPublisher()
        } else {
            return Just("")
                .asAlamofirePublisher
        }
    }
    
}

extension Just {
    var asAlamofirePublisher: AnyPublisher<Output, AFError> {
        setFailureType(to: AFError.self)
            .eraseToAnyPublisher()
    }
}
