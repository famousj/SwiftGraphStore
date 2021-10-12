import Foundation
import Combine
import Alamofire
import UrsusHTTP

public protocol AirlockConnection {
    func requestLogin() -> AnyPublisher<Ship, AFError>
    func requestPoke<T: Encodable>(ship: Ship, app: App, mark: Mark, json: T, handler: @escaping (PokeEvent) -> Void) -> AnyPublisher<Alamofire.Empty, AFError>
    func connect() -> AnyPublisher<String, AFError>
}
