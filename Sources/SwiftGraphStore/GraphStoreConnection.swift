import Foundation
import Combine
import Alamofire
import UrsusHTTP

public protocol GraphStoreConnection {
    var ship: Ship? { get }
    var loggedIn: Bool { get }
    var connected: Bool { get }
    
    func requestLogin() -> AnyPublisher<Ship, AFError>
    func requestConnect() -> AnyPublisher<String, AFError>
    func requestAddGraph(name: Term, handler: @escaping (PokeEvent) -> Void) -> AnyPublisher<Alamofire.Empty, AFError>
}
