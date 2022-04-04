import Foundation
import Combine
import Alamofire
import UrsusHTTP
import os

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
            logger.info("Unable to create a post.  Not logged in.")
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
            .mapError { [weak self] error in
                let loginError = LoginError.fromAFError(error)
                self?.logger.info("Error when logging in: \(error.localizedDescription)")
                
                return loginError
            }
            .eraseToAnyPublisher()
    }
    
    public func requestConnect() -> AnyPublisher<Never, ConnectError> {
        guard let ship = ship else {
            logger.info("Unable to connect.  Not logged in.")
            return Fail(error: .notLoggedIn)
                .eraseToAnyPublisher()
        }
        
        return airlockConnection
            .requestPoke(ship: ship, app: "hood", mark: "helm-hi", json: "airlock connected")
            .mapError { [weak self] error in
                let connectError = ConnectError.fromPokeError(error)
                self?.logger.info("Error when connecting: \(error.localizedDescription)")
                return connectError
            }
            .eraseToAnyPublisher()
    }
    
    public func requestStartSubscription() -> AnyPublisher<Never, StartSubscriptionError> {
        guard let ship = ship else {
            logger.info("Unable to start subscription.  Not logged in.")
            return Fail(error: .notLoggedIn)
                .eraseToAnyPublisher()
        }
        
        return airlockConnection
            .requestStartSubscription(ship: ship,
                                      app: Constants.graphStoreAppName,
                                      path: Constants.graphStoreUpdatePath)
            .mapError { [weak self] error in
                let subscriptionError = StartSubscriptionError.fromAFError(error)
                self?.logger.info("Error when starting subscription: \(error.localizedDescription)")
                return subscriptionError
            }
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
            .mapError { [weak self] error in
                let scryError = ScryError.fromAFError(error)
                self?.logger.info("Error when scrying: \(error.localizedDescription)")
                return scryError
            }
            .eraseToAnyPublisher()
    }
    
    private func doPoke<T: Encodable>(update: T, actionMessage: String) -> AnyPublisher<Never, PokeError> {
        guard let ship = ship else {
            logger.info("Unable to \(actionMessage)t.  Not logged in.")
            
            return Fail(error: PokeError.pokeFailure("Can't \(actionMessage). You aren't logged in!"))
                .mapError { [weak self] error in
                    self?.logger.info("Error when performing poke: \(error.localizedDescription)")
                    return error
                }
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
            logger.info("Unable to scry at \(path.asPath).  Not logged in.")
            
            return Fail(error: .notLoggedIn)
                .eraseToAnyPublisher()
        }
        
        logger.debug("Performing scry at \(path.asPath)")
        
        return airlockConnection
            .requestScry(app: Constants.graphStoreAppName, path: path.asPath)
            .mapError { [weak self] error in
                let scryError = ScryError.fromAFError(error)
                self?.logger.info("Error when scrying: \(error.localizedDescription)")
                return scryError
            }
            .eraseToAnyPublisher()
    }
}
