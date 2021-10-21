import Foundation
import Combine
import Alamofire
import UrsusHTTP

public protocol GraphStoreConnection {
    var ship: Ship? { get }

    func createPost(contents: [Content]?) -> Post?
    func createPost(contents: [Content]?, timeSent: Date) -> Post?
    
    var graphStoreSubscription: AnyPublisher<GraphStoreUpdate, Error> { get }
    
    func requestLogin() -> AnyPublisher<Ship, LoginError>
    func requestConnect() -> AnyPublisher<Never, PokeError>
    func requestStartSubscription() -> AnyPublisher<Never, AFError>
    
    func requestAddGraph(name: Term) -> AnyPublisher<Never, PokeError>
    func requestAddNodes(name: Term, post: Post) -> AnyPublisher<Never, PokeError>
    
    func requestReadGraph(name: Term) -> AnyPublisher<GraphStoreUpdate, ScryError>
}
