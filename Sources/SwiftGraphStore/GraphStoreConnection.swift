import Foundation
import Combine
import Alamofire
import UrsusHTTP

public protocol GraphStoreConnection {
    var ship: Ship? { get }
    
    var graphStoreSubscription: AnyPublisher<String, SubscribeError> { get }
    
    func requestLogin() -> AnyPublisher<Ship, AFError>
    func requestConnect() -> AnyPublisher<Never, PokeError>
    func requestStartSubscription() -> AnyPublisher<Never, AFError>

    func requestAddGraph(name: Term) -> AnyPublisher<Never, PokeError>
}
