import Foundation
import Alamofire
import UrsusHTTP

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
    
    static func fromPokeError(_ error: PokeError) -> ConnectError {
        .connectFailed(message: error.localizedDescription)
    }
}
