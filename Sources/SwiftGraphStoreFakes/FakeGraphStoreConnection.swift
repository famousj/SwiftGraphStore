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
    public var createPost_paramIndex: Index?
    public var createPost_paramContents: [Content]?
    public var createPost_paramTimeSent: Date?
    public var createPost_returnPost: Post?
    public func createPost(index: Index,
                           contents: [Content],
                           timeSent: Date) -> Post? {
        createPost_calledCount += 1
        createPost_paramIndex = index
        createPost_paramContents = contents
        createPost_paramTimeSent = timeSent
        
        return createPost_returnPost
    }
    
    public func createPost(index: Index, contents: [Content]) -> Post? {
        createPost(index: index, contents: contents, timeSent: Date())
    }
    
    public var requestLogin_calledCount = 0
    public var requestLogin_response: Ship?
    public var requestLogin_error: LoginError?
    public func requestLogin() -> AnyPublisher<Ship, LoginError> {
        requestLogin_calledCount += 1
        
        if let error = requestLogin_error {
            return Fail(outputType: Ship.self, failure: error)
                .eraseToAnyPublisher()
        } else {
            return Just(requestLogin_response ?? Ship.testInstance)
                .withErrorType()
        }
    }

    public var requestConnect_calledCount = 0
    public var requestConnect_error: ConnectError?
    public func requestConnect() -> AnyPublisher<Never, ConnectError> {
        requestConnect_calledCount += 1
        
        if let error = requestConnect_error {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
        else {
            return neverPublisher()
        }
    }
    
    public var requestStartSubcription_calledCount = 0
    public var requestStartSubscription_error: StartSubscriptionError?
    public func requestStartSubscription() -> AnyPublisher<Never, StartSubscriptionError> {
        requestStartSubcription_calledCount += 1
        
        if let error = requestStartSubscription_error {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
        else {
            return neverPublisher()
        }
    }
    
    public var requestAddGraph_calledCount = 0
    public var requestAddGraph_paramResource: Resource?
    public var requestAddGraph_error: PokeError?
    public func requestAddGraph(resource: Resource) -> AnyPublisher<Never, PokeError> {
        requestAddGraph_calledCount += 1
        requestAddGraph_paramResource = resource
        
        if let error = requestAddGraph_error {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
        else {
            return neverPublisher()
        }
    }
    
    public var requestAddNodes_calledCount = 0
    public var requestAddNodes_paramResource: Resource?
    public var requestAddNodes_paramPost: Post?
    public var requestAddNodes_paramChildren: Graph?
    public var requestAddNodes_error: PokeError?
    public func requestAddNodes(resource: Resource,
                                post: Post,
                                children: Graph?) -> AnyPublisher<Never, PokeError> {
        requestAddNodes_calledCount += 1
        requestAddNodes_paramResource = resource
        requestAddNodes_paramPost = post
        requestAddNodes_paramChildren = children
        
        if let error = requestAddNodes_error {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
        else {
            return neverPublisher()
        }
    }
    
    public var requestReadKeys_calledCount = 0
    public var requestReadKeys_error: ScryError?
    public var requestReadKeys_returnUpdate: GraphStoreUpdate?
    public func requestReadKeys() -> AnyPublisher<GraphStoreUpdate, ScryError> {
        requestReadKeys_calledCount += 1
        
        if let error = requestReadKeys_error {
            return Fail(outputType: GraphStoreUpdate.self, failure: error)
                .eraseToAnyPublisher()
        }
        else {
            return Just(requestReadKeys_returnUpdate!)
                .withErrorType()
        }
    }
    
    public var requestReadGraph_calledCount = 0
    public var requestReadGraph_paramResource: Resource?
    public var requestReadGraph_error: ScryError?
    public var requestReadGraph_returnUpdate: GraphStoreUpdate?
    public func requestReadGraph(resource: Resource) -> AnyPublisher<GraphStoreUpdate, ScryError> {
        requestReadGraph_calledCount += 1
        requestReadGraph_paramResource = resource
        
        if let error = requestReadGraph_error {
            return Fail(outputType: GraphStoreUpdate.self, failure: error)
                .eraseToAnyPublisher()
        }
        else {
            return Just(requestReadGraph_returnUpdate!)
                .withErrorType()
        }
    }
    
    public var requestReadNode_calledCount = 0
    public var requestReadNode_paramResource: Resource?
    public var requestReadNode_paramIndex: Index?
    public var requestReadNode_paramMode: ScryMode?
    public var requestReadNode_error: ScryError?
    public var requestReadNode_returnUpdate: GraphStoreUpdate?
    public func requestReadNode(resource: Resource, index: Index, mode: ScryMode) -> AnyPublisher<GraphStoreUpdate, ScryError> {
        requestReadNode_calledCount += 1
        requestReadNode_paramResource = resource
        requestReadNode_paramIndex = index
        requestReadNode_paramMode = mode
        
        if let error = requestReadNode_error {
            return Fail(outputType: GraphStoreUpdate.self, failure: error)
                .eraseToAnyPublisher()
        } else {
            return Just(requestReadNode_returnUpdate!)
                .withErrorType()
        }
    }
    
    public var requestReadChildren_calledCount = 0
    public var requestReadChildren_paramResource: Resource?
    public var requestReadChildren_paramIndex: Index?
    public var requestReadChildren_paramMode: ScryMode?
    public var requestReadChildren_error: ScryError?
    public var requestReadChildren_returnUpdate: GraphStoreUpdate?
    public func requestReadChildren(resource: Resource, index: Index, mode: ScryMode) -> AnyPublisher<GraphStoreUpdate, ScryError> {
        requestReadChildren_calledCount += 1
        requestReadChildren_paramResource = resource
        requestReadChildren_paramIndex = index
        requestReadChildren_paramMode = mode
        
        if let error = requestReadChildren_error {
            return Fail(outputType: GraphStoreUpdate.self, failure: error)
                .eraseToAnyPublisher()
        } else {
            return Just(requestReadChildren_returnUpdate!)
                .withErrorType()
        }
    }
    
    public var requestReadRootNodes_calledCount = 0
    public var requestReadRootNodes_paramResource: Resource?
    public var requestReadRootNodes_error: ScryError?
    public var requestReadRootNodes_returnUpdate: GraphStoreUpdate?
    public func requestReadRootNodes(resource: Resource) -> AnyPublisher<GraphStoreUpdate, ScryError> {
        requestReadRootNodes_calledCount += 1
        requestReadRootNodes_paramResource = resource
        
        if let error = requestReadRootNodes_error {
            return Fail(outputType: GraphStoreUpdate.self, failure: error)
                .eraseToAnyPublisher()
        }
        else {
            return Just(requestReadRootNodes_returnUpdate!)
                .withErrorType()
        }
    }
    
    public func requestTestScry(resource: Resource, path: Path) -> AnyPublisher<String, ScryError> {
        Just("")
            .setFailureType(to: ScryError.self)
            .eraseToAnyPublisher()
    }
    
        
}
