import Foundation
import Combine
import Alamofire
import UrsusHTTP

public protocol GraphStoreConnection {
    var ship: Ship? { get }

    var graphStoreSubscription: AnyPublisher<GraphStoreUpdate, Error> { get }

    func createPost(contents: [Content]?) -> Post?
    func createPost(contents: [Content]?, timeSent: Date) -> Post?

    func requestLogin() -> AnyPublisher<Ship, LoginError>
    func requestConnect() -> AnyPublisher<Never, PokeError>
    func requestStartSubscription() -> AnyPublisher<Never, AFError>
    
    func requestAddGraph(resource: Resource) -> AnyPublisher<Never, PokeError>
    func requestAddNodes(resource: Resource, post: Post) -> AnyPublisher<Never, PokeError>
    
    func requestReadGraph(resource: Resource) -> AnyPublisher<GraphStoreUpdate, ScryError>
    
    func requestTestScry(resource: Resource, path: Path) -> AnyPublisher<String, ScryError>
}
