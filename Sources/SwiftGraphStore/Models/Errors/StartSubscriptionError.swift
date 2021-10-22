import Foundation
import Alamofire

public enum StartSubscriptionError: LocalizedError {
    
    case notLoggedIn
    case startSubscriptionFailed(message: String)
    
    public var errorDescription: String? {
        switch self {
        case .notLoggedIn:
            return "you aren't logged in!"
        case .startSubscriptionFailed(let message):
            return message
        }
    }
    
    // TODO: Add more expected errors
    static func fromAFError(_ error: AFError) -> StartSubscriptionError {
        .startSubscriptionFailed(message: error.localizedDescription)
    }
}
