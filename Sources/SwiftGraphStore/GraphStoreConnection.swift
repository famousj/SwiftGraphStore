import Foundation
import Combine
import UrsusHTTP

public protocol GraphStoreConnection {
    var ship: Ship? { get }

    var graphStoreSubscription: AnyPublisher<GraphStoreUpdate, Error> { get }

    func createPost(index: String, contents: [Content]?) -> Post?
    func createPost(index: String, contents: [Content]?, timeSent: Date) -> Post?

    func requestLogin() -> AnyPublisher<Ship, LoginError>
    func requestConnect() -> AnyPublisher<Never, PokeError>
    func requestStartSubscription() -> AnyPublisher<Never, StartSubscriptionError>
    
    func requestAddGraph(resource: Resource) -> AnyPublisher<Never, PokeError>
    func requestAddNodes(resource: Resource, index: String, post: Post) -> AnyPublisher<Never, PokeError>

    func requestReadKeys() -> AnyPublisher<GraphStoreUpdate, ScryError>
    func requestReadGraph(resource: Resource) -> AnyPublisher<GraphStoreUpdate, ScryError>
    
    func requestTestScry(resource: Resource, path: Path) -> AnyPublisher<String, ScryError>
}
