import Foundation
import Alamofire
import UrsusHTTP
import UrsusAtom

public class UrsusHTTPConnection: AirlockConnection {
    private let client: Client
    
    public private(set) var ship: Ship?
    
    public init(url: URL, code: PatP) {
        self.client = Client(url: url, code: code)
    }

    public func loginRequest(handler: @escaping (AFResult<Ship>) -> Void) -> DataRequest {
        client.loginRequest { result in
           if case let .success(ship) = result {
               self.ship = ship
            }
            
            handler(result)
        }
    }
    
    public func pokeRequest<T: Encodable>(ship: Ship, app: App, mark: Mark, json: T, handler: @escaping (PokeEvent) -> Void) -> DataRequest {
        client.pokeRequest(ship: ship, app: app, mark: mark, json: json, handler: handler)
    }

}
