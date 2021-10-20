import Foundation
import Alamofire

public enum LoginError: LocalizedError {
    
    case offline
    case invalidURL(URL?)
    case invalidHost(URL?)
    case loginFailed
    
    public var errorDescription: String? {
        switch self {
        case .offline:
            return "You appear to be offline"
        case .invalidURL(let url):
            if let url = url {
                return "Invalid URL: \(url)"
            } else {
                return "Invalid URL"
            }
        case .invalidHost(let url):
            var error: String
            if let url = url,
               let host = url.host {
                error = "Couldn't connect to \(host)."
            } else {
                error = "Couldn't connect to your URL."
            }
            return error + " Please check your URL and try again."
        case .loginFailed:
            return "Couldn't log in! Please check your URL and code, and then try again."
        }
    }
    
    // TODO: test this
    static func fromAFError(_ error: AFError) -> LoginError {
        switch error {
        case .invalidURL(let url):
            return .invalidURL(try? url.asURL())
        case .responseValidationFailed:
            return .loginFailed
        case .sessionTaskFailed(let sessionTaskError):
            if let urlError = sessionTaskError as? URLError {
                switch urlError.code {
                case .badURL:
                    return .invalidURL(urlError.failingURL)
                case .unsupportedURL:
                    return .invalidURL(urlError.failingURL)
                case .notConnectedToInternet:
                    return .offline
                default:
                    return .loginFailed
                }
            }
            return .loginFailed
        default:
            return .loginFailed
        }
    }
}
