import Foundation
import Alamofire

public enum ConnectError: LocalizedError {
    
    case notLoggedIn
    case connectFailed(message: String)
    
    public var errorDescription: String? {
        switch self {
        case .notLoggedIn:
            return "you aren't logged in!"
        case .connectFailed(let message):
            return message
        }
    }
    
    static func fromAFError(_ error: AFError) -> ConnectError {
        .connectFailed(message: error.localizedDescription)
    }
}
