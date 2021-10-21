import Foundation
import Alamofire

public enum ScryError: LocalizedError {
    
    case scryFailed(message: String)
    
    public var errorDescription: String? {
        switch self {
        case .scryFailed(let message):
            return "Unable to read from ship: \(message)"
        }
    }
    
    // TODO: Add more expected errors
    static func fromAFError(_ error: AFError) -> ScryError {
        .scryFailed(message: error.localizedDescription)
    }
}
