import Foundation
import Alamofire

public enum ScryError: LocalizedError {
    
    case notLoggedIn
    case resourceNotFound(url: URL?)
    case scryFailed(message: String)
    
    public var errorDescription: String? {
        switch self {
        case .notLoggedIn:
            return "you aren't logged in!"
        case .resourceNotFound(let url):
            return "I couldn't find anything at " + urlString(url)
        case .scryFailed(let message):
            return message
        }
    }
    
    private func urlString(_ url: URL?) -> String {
        guard let url = url else {
            return "your URL"
        }
        return url.absoluteString
    }
    
    // TODO: Add more expected errors
    static func fromAFError(_ error: AFError) -> ScryError {
        if case .responseValidationFailed(let reason) = error,
           case .unacceptableStatusCode(let code) = reason,
           code == 404 {
            return .resourceNotFound(url: error.url)
        }
        
        return .scryFailed(message: error.localizedDescription)
    }
}
