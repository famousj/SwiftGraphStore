import Foundation
import Combine
import Alamofire
import UrsusHTTP

public class AirlockGraphStoreConnection: GraphStoreConnection {
    public private(set) var ship: Ship?
    
    private let airlockConnection: AirlockConnection
    public let graphStoreSubscription: AnyPublisher<GraphStoreUpdate, Error>
    
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
}
