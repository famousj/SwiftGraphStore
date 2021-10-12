import Foundation
import Combine
import Alamofire
import UrsusHTTP

public class AirlockGraphStoreConnection: GraphStoreConnection {
    
    public private(set) var ship: Ship?
    
    public private(set) var loggedIn: Bool = false
    
    public private(set) var connected: Bool = false
    
    private let airlockConnection: AirlockConnection
    
    public init(airlockConnection: AirlockConnection) {
        self.airlockConnection = airlockConnection
    }
    
    public func requestLogin() -> AnyPublisher<Ship, AFError> {
        airlockConnection
            .requestLogin()
            .map { ship in
                self.ship = ship
                self.loggedIn = true
                
                return ship
            }
            .eraseToAnyPublisher()
    }
    
    public func requestConnect() -> AnyPublisher<String, AFError> {
        guard loggedIn,
              let ship = ship else {
                  return Fail(error: AFError.createURLRequestFailed(error: NSError()))
                      .eraseToAnyPublisher()
              }
        
        return airlockConnection
            .requestPoke(ship: ship, app: "hood", mark: "helm-hi", json: "iOS airlock connected") { pokeEvent in
                print("Here's an event: \(pokeEvent)")
            }
            .flatMap { _ -> AnyPublisher<String, AFError> in
                self.airlockConnection.connect()
            } 
            .map { value in
                self.connected = true
                return value
            }
            .eraseToAnyPublisher()
    }

    
    public func requestAddGraph(name: Term, handler: @escaping (PokeEvent) -> Void) -> AnyPublisher<Alamofire.Empty, AFError> {
        // TODO: test me
        guard loggedIn, let ship = ship else {
            return Fail(outputType: Alamofire.Empty.self, failure: AFError.createURLRequestFailed(error: NSError()))
                .eraseToAnyPublisher()
        }
        
        //        let app = "graph-store"
        //        let mark = "graph-update-2"
        let resource = Resource(ship: ship, name: name)
        let params = AddGraphParams(resource: resource,
                                    graph: [:],
                                    mark: nil,
                                    overwrite: true)
        let update = AddGraphAction(addGraph: params)
        
        return airlockConnection
            .requestPoke(ship: ship, app: Constants.appName, mark: Constants.graphStoreUpdateMark, json: update, handler: handler)
        
        //
        //
        //        self.client
        //            .pokeRequest(ship: ship, app: app, mark: mark, json: update) { event in
        //
        //                print("EVENT TIME!! \(event)")
        //                if case let .failure(error) = event {
        //                    print("request had an error of some kind: \(error.localizedDescription)")
        //                    self.responseErrorMessage = error.localizedDescription
        //                    self.responseError = true
        //                    self.doingPoke = false
        //                    return
        //                }
        //                print("Poke successfully sent!")
        //                self.doingPoke = false
        //
        //            }
        //            .response { _ in
        //                self.client
        //                    .connect()
        //            }
    }
}
