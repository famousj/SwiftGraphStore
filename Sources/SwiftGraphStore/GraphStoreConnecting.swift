import Foundation
import Combine
import UrsusHTTP

public protocol GraphStoreConnecting {
    var ship: Ship? { get }

    var graphStoreSubscription: AnyPublisher<GraphStoreUpdate, Error> { get }

    func createPost(index: Index, contents: [Content]) -> Post?
    func createPost(index: Index, contents: [Content], timeSent: Date) -> Post?

    func requestLogin() -> AnyPublisher<Ship, LoginError>
    func requestConnect() -> AnyPublisher<Never, ConnectError>
    func requestStartSubscription() -> AnyPublisher<Never, StartSubscriptionError>
    
    func requestAddGraph(resource: Resource) -> AnyPublisher<Never, PokeError>
    func requestAddNodes(resource: Resource, post: Post) -> AnyPublisher<Never, PokeError>
    func requestAddNodes(resource: Resource, post: Post, children: [Index: Graph]?) -> AnyPublisher<Never, PokeError>

    func requestReadKeys() -> AnyPublisher<GraphStoreUpdate, ScryError>
    func requestReadGraph(resource: Resource) -> AnyPublisher<GraphStoreUpdate, ScryError>
    func requestReadNode(resource: Resource, index: Index, mode: ScryMode) -> AnyPublisher<GraphStoreUpdate, ScryError>
    func requestReadRootNodes(resource: Resource) -> AnyPublisher<GraphStoreUpdate, ScryError>
    
    func requestTestScry(resource: Resource, path: Path) -> AnyPublisher<String, ScryError>
}

extension GraphStoreConnecting {
    public func requestAddNodes(resource: Resource, post: Post) -> AnyPublisher<Never, PokeError> {
        return requestAddNodes(resource: resource,
                               post: post,
                               children: nil)
    }
}
