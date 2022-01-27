import Foundation
import Combine
import Alamofire
import UrsusHTTP
import os

// TODO: Log errors and not-logged-in errors
public class GraphStoreConnection: GraphStoreConnecting {
    private let logger = Logger()
    public internal(set) var ship: Ship?
    
    private let airlockConnection: AirlockConnecting
    public let graphStoreSubscription: AnyPublisher<GraphStoreUpdate, Error>
    
    public func createPost(index: Index, contents: [Content]) -> Post? {
        createPost(index: index, contents: contents, timeSent: Date())
    }

    public func createPost(index: Index, contents: [Content], timeSent: Date) -> Post? {
        guard let ship = ship else {
            print("Can't make a post!  Not logged in.")
            return nil
        }
        
        return Post(author: ship, index: index, timeSent: timeSent, contents: contents, hash: nil, signatures: [])
    }
    
    public init(airlockConnection: AirlockConnecting) {
        self.airlockConnection = airlockConnection
        
        graphStoreSubscription = airlockConnection
            .graphStoreSubscription
            .decode(type: GraphStoreUpdate.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    public func requestLogin() -> AnyPublisher<Ship, LoginError> {
        airlockConnection
            .requestLogin()
            .map { ship in
                self.ship = ship
                return ship
            }
            .mapError { error in
                let loginError = LoginError.fromAFError(error)
                return loginError
            }
            .eraseToAnyPublisher()
    }
    
    public func requestConnect() -> AnyPublisher<Never, ConnectError> {
        guard let ship = ship else {
            return Fail(error: .notLoggedIn)
                .eraseToAnyPublisher()
        }
        
        return airlockConnection
            .requestPoke(ship: ship, app: "hood", mark: "helm-hi", json: "airlock connected")
            .mapError { .fromPokeError($0) }
            .eraseToAnyPublisher()
    }
    
    public func requestStartSubscription() -> AnyPublisher<Never, StartSubscriptionError> {
        guard let ship = ship else {
            return Fail(error: .notLoggedIn)
                .eraseToAnyPublisher()
        }
        
        return airlockConnection
            .requestStartSubscription(ship: ship,
                                      app: Constants.graphStoreAppName,
                                      path: Constants.graphStoreUpdatePath)
            .mapError { .fromAFError($0) }
            .eraseToAnyPublisher()
    }
    
    public func requestAddGraph(resource: Resource) -> AnyPublisher<Never, PokeError> {
        let update = GraphUpdate.addGraph(resource: resource, graph: [:], mark: nil, overwrite: true)
        
        return doPoke(update: update, actionMessage: "add a graph")
    }
    
    public func requestAddNodes(resource: Resource,
                                post: Post,
                                children: Graph?) -> AnyPublisher<Never, PokeError> {
        let updateNodes = [post.index: Node(post: post, children: children)]
        let update = GraphUpdate.addNodes(resource: resource, nodes: updateNodes)
        return doPoke(update: update, actionMessage: "add a node")
    }
    
    public func requestReadGraph(resource: Resource) -> AnyPublisher<GraphStoreUpdate, ScryError> {
        doScry(path: .graph(resource: resource))
    }
    
    public func requestReadNode(resource: Resource, index: Index, mode: ScryMode) -> AnyPublisher<GraphStoreUpdate, ScryError> {
        doScry(path: .node(resource: resource, index: index, mode: mode))
    }
    
    public func requestReadChildren(resource: Resource, index: Index, mode: ScryMode) -> AnyPublisher<GraphStoreUpdate, ScryError> {
        doScry(path: .children(resource: resource, index: index, mode: mode))
    }
    
    public func requestReadKeys() -> AnyPublisher<GraphStoreUpdate, ScryError> {
        doScry(path: .keys)
    }
    
    public func requestReadRootNodes(resource: Resource) -> AnyPublisher<GraphStoreUpdate, ScryError> {
        doScry(path: .rootNodes(resource: resource))
    }
    
    public func requestTestScry(resource: Resource, path: Path) -> AnyPublisher<String, ScryError> {
        guard let _ = ship else {
            return Fail(error: .notLoggedIn)
                .eraseToAnyPublisher()
        }
        
        return airlockConnection
            .requestTestScry(app: Constants.graphStoreAppName, path: path)
            .mapError { ScryError.fromAFError($0) }
            .eraseToAnyPublisher()
    }
    
    private func doPoke<T: Encodable>(update: T, actionMessage: String) -> AnyPublisher<Never, PokeError> {
        guard let ship = ship else {
            return Fail(error: PokeError.pokeFailure("Can't \(actionMessage). You aren't logged in!"))
                .eraseToAnyPublisher()
        }

        return airlockConnection
            .requestPoke(ship: ship,
                         app: Constants.graphStoreAppName,
                         mark: Constants.graphStoreUpdateMark,
                         json: update)
            .eraseToAnyPublisher()
    }
    
    private func doScry(path: ScryPath) -> AnyPublisher<GraphStoreUpdate, ScryError> {
        guard let _ = ship else {
            return Fail(error: .notLoggedIn)
                .eraseToAnyPublisher()
        }
        
        logger.debug("Performing scry at \(path.asPath)")

        return airlockConnection
            .requestScry(app: Constants.graphStoreAppName, path: path.asPath)
            .mapError { ScryError.fromAFError($0) }
            .eraseToAnyPublisher()
    }
}
