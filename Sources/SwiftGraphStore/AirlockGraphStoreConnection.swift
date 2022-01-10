import Foundation
import Combine
import Alamofire
import UrsusHTTP

public class AirlockGraphStoreConnection: GraphStoreConnecting {
    public internal(set) var ship: Ship?
    
    private let airlockConnection: AirlockConnection
    public let graphStoreSubscription: AnyPublisher<GraphStoreUpdate, Error>
    
    public func createPost(index: String, contents: [Content]?) -> Post? {
        createPost(index: index, contents: contents, timeSent: Date())
    }

    public func createPost(index: String, contents: [Content]?, timeSent: Date) -> Post? {
        guard let ship = ship else {
            print("Can't make a post!  Not logged in.")
            return nil
        }
        
        return Post(author: ship, index: index, timeSent: timeSent, contents: contents, hash: nil, signatures: [])
    }
    
    public init(airlockConnection: AirlockConnection) {
        self.airlockConnection = airlockConnection
        
        graphStoreSubscription = airlockConnection
            .graphStoreSubscription
            .decode(type: GraphStoreUpdate.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    // TODO: Automatically add some kind of http or https when it's missing from the URL
    // TODO: Automatically upgrade your connection to https when you get this error
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
    
    public func requestConnect() -> AnyPublisher<Never, PokeError> {
        guard let ship = ship else {
            return Fail(error: PokeError.pokeFailure("Unable to connect!  Not logged in."))
                .eraseToAnyPublisher()
        }
        
        return airlockConnection
            .requestPoke(ship: ship, app: "hood", mark: "helm-hi", json: "airlock connected")
    }
    
    public func requestStartSubscription() -> AnyPublisher<Never, StartSubscriptionError> {
        guard let ship = ship else {
            return Fail(error: .notLoggedIn)
                .eraseToAnyPublisher()
        }
        
        return airlockConnection
            .requestStartSubscription(ship: ship, app: Constants.graphStoreAppName, path: Constants.graphStoreUpdatePath)
            .mapError { .fromAFError($0) }
            .eraseToAnyPublisher()
    }
    
    public func requestAddGraph(resource: Resource) -> AnyPublisher<Never, PokeError> {
        let update = GraphUpdate.addGraph(resource: resource, graph: [:], mark: nil, overwrite: true)
        
        return doPoke(update: update, actionMessage: "add a graph")
    }
    
    // TODO: do an error if the post index doesn't agree with the index param
    public func requestAddNodes(resource: Resource, index: String, post: Post) -> AnyPublisher<Never, PokeError> {
        let updateNodes = [index: Graph(post: post, children: nil)]
        let update = GraphUpdate.addNodes(resource: resource, nodes: updateNodes)
        
        return doPoke(update: update, actionMessage: "add a node")
    }
    
    public func requestReadGraph(resource: Resource) -> AnyPublisher<GraphStoreUpdate, ScryError> {
        doScry(path: .graph(resource: resource))
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

        return airlockConnection
            .requestScry(app: Constants.graphStoreAppName, path: path.asPath)
            .mapError { ScryError.fromAFError($0) }
            .eraseToAnyPublisher()
    }
}
