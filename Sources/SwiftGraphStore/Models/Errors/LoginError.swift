import Foundation
import Alamofire

public enum LoginError: LocalizedError {
    
    case offline
    case shipNotRunning
    case invalidURL(URL?)
    case invalidHost(URL?)
    case httpsRequired
    case badCode
    case loginFailed
    
    public var errorDescription: String? {
        switch self {
        case .offline:
            return "You aren't connected to the internet!"
        case .invalidURL(let url):
            if let url = url {
                return "Invalid URL: \(url)"
            } else {
                return "Invalid URL"
            }
        case .httpsRequired:
            return "I can only connect to ships running a secure connection. Please go here to see how to setup HTTPS:\n https://urbit.org/using/os/basics"
        case .invalidHost(let url):
            var error: String
            if let url = url,
               let host = url.host {
                error = "Couldn't connect to \(host)."
            } else {
                error = "Couldn't connect to your URL."
            }
            return error + " Check your URL and try again."
        case .shipNotRunning:
            return "Could not connect to the URL.  Make sure your ship is running and try again."
        case .badCode:
            return "Your code did not work.  Check your code and URL, and try again"
        case .loginFailed:
            return "Check your URL and code, make sure your ship is running, and then try again."
        }
    }
    
    static func fromAFError(_ error: AFError) -> LoginError {
        switch error {
        case .responseValidationFailed(let reason):
            switch reason {
            case .unacceptableStatusCode(let code):
                switch code {
                case 400:
                    return .badCode
                case 404:
                    return .invalidHost(error.url)
                case 502:
                    return .invalidHost(error.url)
                default:
                    return .loginFailed
                }
            default:
                return .loginFailed
            }
            
        case .sessionTaskFailed(let sessionTaskError):
            if let urlError = sessionTaskError as? URLError {
                switch urlError.code {
                case .appTransportSecurityRequiresSecureConnection:
                    return .httpsRequired
                case .cannotConnectToHost:
                    return .shipNotRunning
                case .unsupportedURL:
                    return .invalidURL(urlError.failingURL)
                case .notConnectedToInternet:
                    return .offline
                case .cannotFindHost:
                    return .invalidHost(urlError.failingURL)
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
