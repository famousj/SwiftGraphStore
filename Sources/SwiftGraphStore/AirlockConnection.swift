import Foundation
import Alamofire
import UrsusHTTP

public protocol AirlockConnection {
    var ship: Ship? { get }
    func loginRequest(handler: @escaping (AFResult<Ship>) -> Void) -> DataRequest
    func pokeRequest<T: Encodable>(ship: Ship, app: App, mark: Mark, json: T, handler: @escaping (PokeEvent) -> Void) -> DataRequest
}
