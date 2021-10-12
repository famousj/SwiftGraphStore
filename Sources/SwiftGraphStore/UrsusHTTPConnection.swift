import Foundation
import Combine
import Alamofire
import UrsusHTTP
import UrsusAtom

public class UrsusHTTPConnection: AirlockConnection {
    private let client: Client
    
    public private(set) var ship: Ship?
    
    public init(url: URL, code: PatP) {
        self.client = Client(url: url, code: code)
    }
    
    public func requestLogin() -> AnyPublisher<Ship, AFError> {
        client
            .loginRequestPublisher()
    }
    
    public func requestPoke<T: Encodable>(ship: Ship, app: App, mark: Mark, json: T, handler: @escaping (PokeEvent) -> Void) -> AnyPublisher<Alamofire.Empty, AFError> {
        client
            .pokeRequest(ship: ship, app: app, mark: mark, json: json, handler: handler)
            .publishDecodable()
            .value()
            .eraseToAnyPublisher()
    }
    
    public func connect() -> AnyPublisher<String, AFError> {
        client
            .connect()
            .publishString()
            .value()
            .eraseToAnyPublisher()
    }
}
