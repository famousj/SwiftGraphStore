import Foundation
import Combine


extension Just {
    func withErrorType<E: Error>() -> AnyPublisher<Output, E> {
        setFailureType(to: E.self)
            .eraseToAnyPublisher()
    }
    
    func neverOutput<E: Error>() -> AnyPublisher<Never, E> {
        withErrorType()
            .ignoreOutput()
            .eraseToAnyPublisher()
    }
}

func neverPublisher<E: Error>() -> AnyPublisher<Never, E> {
    Just(true)
        .neverOutput()
}

