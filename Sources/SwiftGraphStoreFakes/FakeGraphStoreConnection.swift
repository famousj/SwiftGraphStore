import Foundation
import Combine
import SwiftGraphStore
import UrsusHTTP

public class FakeGraphStoreConnection: GraphStoreConnecting {
    

    public init() {}
    
    public var ship: Ship?
    
    public var graphStoreSubscriptionSubject: PassthroughSubject<GraphStoreUpdate, Error> = PassthroughSubject()
    public var graphStoreSubscription: AnyPublisher<GraphStoreUpdate, Error> {
        graphStoreSubscriptionSubject
            .eraseToAnyPublisher()
    }
    
    public var createPost_calledCount = 0
    public var createPost_paramIndex: String?
    public var createPost_paramContents: [Content]?
    public var createPost_paramTimeSent: Date?
    public var createPost_returnPost: Post?
    public func createPost(index: String,
                           contents: [Content]?,
                           timeSent: Date) -> Post? {
        createPost_calledCount += 1
        createPost_paramIndex = index
        createPost_paramContents = contents
        createPost_paramTimeSent = timeSent
        
        return createPost_returnPost
    }
    
    public func createPost(index: String, contents: [Content]?) -> Post? {
        createPost(index: index, contents: contents, timeSent: Date())
    }
    
    public var requestLogin_calledCount = 0
    public var loginSubject: PassthroughSubject<Ship, LoginError> = PassthroughSubject()
    public func requestLogin() -> AnyPublisher<Ship, LoginError> {
        requestLogin_calledCount += 1
        
        return loginSubject
            .eraseToAnyPublisher()
    }

    public var requestConnect_calledCount = 0
    public var connectSubject: PassthroughSubject<Never, PokeError> = PassthroughSubject()
    public func requestConnect() -> AnyPublisher<Never, PokeError> {
        requestConnect_calledCount += 1
        
        return connectSubject
            .eraseToAnyPublisher()
    }
    
    public var requestStartSubcription_calledCount = 0
    public var startSubscriptionSubject: PassthroughSubject<Never, StartSubscriptionError> = PassthroughSubject()
    public func requestStartSubscription() -> AnyPublisher<Never, StartSubscriptionError> {
        requestStartSubcription_calledCount += 1
        return startSubscriptionSubject
            .eraseToAnyPublisher()
    }
    
    public var requestAddGraph_calledCount = 0
    public var requestAddGraph_paramResource: Resource?
    public var addGraphSubject: PassthroughSubject<Never, PokeError> = PassthroughSubject()
    public func requestAddGraph(resource: Resource) -> AnyPublisher<Never, PokeError> {
        requestAddGraph_calledCount += 1
        requestAddGraph_paramResource = resource
        
        return addGraphSubject
            .eraseToAnyPublisher()
    }
    
    public var requestAddNodes_calledCount = 0
    public var requestAddNodes_paramResource: Resource?
    public var requestAddNodes_paramIndex: String?
    public var requestAddNodes_paramPost: Post?
    public var addNodesSubject: PassthroughSubject<Never, PokeError> = PassthroughSubject()
    public func requestAddNodes(resource: Resource, index: String, post: Post) -> AnyPublisher<Never, PokeError> {
        requestAddNodes_calledCount += 1
        requestAddNodes_paramResource = resource
        requestAddNodes_paramIndex = index
        requestAddNodes_paramPost = post
        
        return addNodesSubject
            .eraseToAnyPublisher()
    }
    
    public var requestReadKeys_calledCount = 0
    public var readKeysSubject: PassthroughSubject<GraphStoreUpdate, ScryError> = PassthroughSubject()
    public func requestReadKeys() -> AnyPublisher<GraphStoreUpdate, ScryError> {
        requestReadKeys_calledCount += 1
        
        return readKeysSubject
            .eraseToAnyPublisher()
    }
    
    public var requestReadGraph_calledCount = 0
    public var requestReadGraph_paramResource: Resource?
    public var readGraphSubject: PassthroughSubject<GraphStoreUpdate, ScryError> = PassthroughSubject()
    public func requestReadGraph(resource: Resource) -> AnyPublisher<GraphStoreUpdate, ScryError> {
        requestReadGraph_calledCount += 1
        requestReadGraph_paramResource = resource
        
        return readGraphSubject
            .eraseToAnyPublisher()
    }
    
    public var requestReadRootNodes_calledCount = 0
    public var requestReadRootNodes_paramResource: Resource?
    public var readRootNotesSubject: PassthroughSubject<GraphStoreUpdate, ScryError> = PassthroughSubject()
    public func requestReadRootNodes(resource: Resource) -> AnyPublisher<GraphStoreUpdate, ScryError> {
        requestReadRootNodes_calledCount += 1
        requestReadRootNodes_paramResource = resource
        
        return readRootNotesSubject
            .eraseToAnyPublisher()
    }
    
    public func requestTestScry(resource: Resource, path: Path) -> AnyPublisher<String, ScryError> {
        Just("")
            .setFailureType(to: ScryError.self)
            .eraseToAnyPublisher()
    }
    
        
}
