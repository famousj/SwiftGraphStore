import Foundation
import Alamofire

public enum ScryError: LocalizedError {
    
    case notLoggedIn
    case scryFailed(message: String)
    
    public var errorDescription: String? {
        switch self {
        case .notLoggedIn:
            return "you aren't logged in!"
        case .scryFailed(let message):
            return message
        }
    }
    
    // TODO: Add more expected errors
    static func fromAFError(_ error: AFError) -> ScryError {
        .scryFailed(message: error.localizedDescription)
    }
}
