import Foundation
import Combine
import Alamofire
import UrsusHTTP

public class AirlockGraphStoreConnection: GraphStoreConnection {
    public internal(set) var ship: Ship?
    
    private let airlockConnection: AirlockConnection
    public let graphStoreSubscription: AnyPublisher<GraphStoreUpdate, Error>
    
    public func createPost(contents: [Content]?) -> Post? {
        createPost(contents: contents, timeSent: Date())
    }

    public func createPost(contents: [Content]?, timeSent: Date) -> Post? {
        guard let ship = ship else {
            print("Can't make a post!  Not logged in.")
            return nil
        }
        
        let index = "/\(Int(timeSent.timeIntervalSince1970))"

        return Post(author: ship, index: index, timeSent: timeSent, contents: contents, hash: nil, signatures: [])
    }
    
    public init(airlockConnection: AirlockConnection) {
        self.airlockConnection = airlockConnection
        
        graphStoreSubscription = airlockConnection
            .graphStoreSubscription
            .tryMap { data -> GraphStoreUpdate in
                let decoder = JSONDecoder()
                return try decoder.decode(GraphStoreUpdate.self, from: data)
            }
            .eraseToAnyPublisher()
    }
    
    public func requestLogin() -> AnyPublisher<Ship, AFError> {
        airlockConnection
            .requestLogin()
            .map { ship in
                self.ship = ship
                return ship
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
    
    public func requestStartSubscription() -> AnyPublisher<Never, AFError> {
        guard let ship = ship else {
            return Fail(error: AFError.createURLRequestFailed(error: NSError()))
                .eraseToAnyPublisher()
        }
        
        return airlockConnection
            .requestStartSubscription(ship: ship, app: Constants.graphStoreAppName, path: Constants.graphStoreUpdatePath)
    }
    
    public func requestScry(path: Path) -> AnyPublisher<String, AFError> {
        guard let _ = ship else {
            return Fail(error: AFError.createURLRequestFailed(error: NSError()))
                .eraseToAnyPublisher()
        }
        
        return airlockConnection
            .requestScry(app: Constants.graphStoreAppName, path: path)
    }

    public func requestAddGraph(name: Term) -> AnyPublisher<Never, PokeError> {
        guard let ship = ship else {
            return Fail(error: PokeError.pokeFailure("Can't add a graph. You aren't logged in!"))
                .eraseToAnyPublisher()
        }

        let resource = Resource(ship: ship, name: name)
        let update = GraphUpdate.addGraph(resource: resource, graph: Graph(), mark: nil, overwrite: true)

        return airlockConnection
            .requestPoke(ship: ship,
                         app: Constants.graphStoreAppName,
                         mark: Constants.graphStoreUpdateMark,
                         json: update)
            .eraseToAnyPublisher()
    }
    
    public func requestAddNodes(name: Term, post: Post) -> AnyPublisher<Never, PokeError> {
        guard let ship = ship else {
            return Fail(error: PokeError.pokeFailure("Can't add a node. You aren't logged in!"))
                .eraseToAnyPublisher()
        }

        let resource = Resource(ship: ship, name: name)
        let index = post.index
        let updateNodes = [index: UpdateNode(post: post, children: nil)]
        
        let update = GraphUpdate.addNodes(resource: resource, nodes: updateNodes)

        return airlockConnection
            .requestPoke(ship: ship,
                         app: Constants.graphStoreAppName,
                         mark: Constants.graphStoreUpdateMark,
                         json: update)
            .eraseToAnyPublisher()
    }
}
