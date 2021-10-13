import Foundation
import Combine
import Alamofire
import UrsusHTTP

public protocol AirlockConnection {
    var graphStoreSubscription: AnyPublisher<Data, SubscribeError> { get }
    
    func requestLogin() -> AnyPublisher<Ship, AFError>
    func requestPoke<T: Encodable>(ship: Ship, app: App, mark: Mark, json: T) -> AnyPublisher<Never, PokeError>
    func requestStartSubscription(ship: Ship, app: App, path: Path) -> AnyPublisher<Never, AFError>
}
