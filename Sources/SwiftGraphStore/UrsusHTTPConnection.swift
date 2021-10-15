import Foundation
import Combine
import Alamofire
import UrsusHTTP
import UrsusAtom

public class UrsusHTTPConnection: AirlockConnection {
    
    private var graphStoreSubject = PassthroughSubject<Data, SubscribeError>()
    public var graphStoreSubscription: AnyPublisher<Data, SubscribeError> {
        graphStoreSubject.eraseToAnyPublisher()
    }
    
    private let client: Client
    
    public private(set) var ship: Ship?
    
    public init(url: URL, code: Code) {
        self.client = Client(url: url, code: code)
    }
    
    public func requestLogin() -> AnyPublisher<Ship, AFError> {
        Future { promise in
            self.client
                .loginRequest(handler: { result in
                    promise(result)
                })
        }
        .eraseToAnyPublisher()
    }
    
    public func requestPoke<T: Encodable>(ship: Ship, app: App, mark: Mark, json: T) -> AnyPublisher<Never, PokeError> {
        let subject = PassthroughSubject<Never, PokeError>()
        
        client
            .pokeRequest(ship: ship, app: app, mark: mark, json: json) { pokeEvent in
                switch pokeEvent {
                case .finished:
                    subject.send(completion: .finished)
                case .failure(let pokeError):
                    subject.send(completion: .failure(pokeError))
                }
            }
            .response { _ in
                self.client
                    .connect()
            }
        
        return subject
            .eraseToAnyPublisher()
    }
    
    public func requestStartSubscription(ship: Ship, app: App, path: Path) -> AnyPublisher<Never, AFError> {
        let subject = PassthroughSubject<Never, AFError>()
        
        client
            .subscribeRequest(ship: ship, app: app, path: path) { event in
                switch event {
                case .started:
                    print("Subscription started")
                    break
                case .failure(let subscribeError):
                    self.graphStoreSubject.send(completion: .failure(subscribeError))
                case .update(let data):
                    self.graphStoreSubject.send(data)
                case .finished:
                    self.graphStoreSubject.send(completion: .finished)
                }
            }
            .response { response in
                switch response.result {
                case .failure(let error):
                    subject.send(completion: .failure(error))
                case .success:
                    subject.send(completion: .finished)
                }
            }
        
        return subject.eraseToAnyPublisher()
    }
}
