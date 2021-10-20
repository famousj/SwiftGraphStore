import XCTest
import Alamofire

@testable import SwiftGraphStore

final class LoginErrorTests: XCTestCase {
    func test_fromAFError_whenNotConnected_returnsOffline() throws {
        let urlError = URLError(URLError.Code.notConnectedToInternet)
        let afError = AFError.sessionTaskFailed(error: urlError)
        
        let loginError = LoginError.fromAFError(afError)
        
        guard case .offline = loginError else {
            XCTFail("LoginError should have been .offline")
            return
        }
    }
    
    func test_fromAFError_whenBadProtocol_returnsOffline() throws {
        // You get this when you enter a URL like "htt://ship.urbit.org"
        let urlError = URLError(URLError.Code.unsupportedURL)
        let afError = AFError.sessionTaskFailed(error: urlError)
        
        let loginError = LoginError.fromAFError(afError)
        
        guard case .invalidURL = loginError else {
            XCTFail("LoginError should have been .invalidURL")
            return
        }
    }
    
    func test_fromAFError_whenAddressNotFound_returnsInvalidHost() throws {
        // You get this when the host fails DNS lookup
        let urlError = URLError(URLError.Code.cannotFindHost)
        let afError = AFError.sessionTaskFailed(error: urlError)
        
        let loginError = LoginError.fromAFError(afError)
        
        guard case .invalidHost = loginError else {
            XCTFail("LoginError should have been .invalidHost")
            return
        }
    }
    
    func test_fromAFError_whenCannotConnectToHost_returnsShipNotRunning() throws {
        // You get this when the host doesn't respond
        let urlError = URLError(URLError.Code.cannotConnectToHost)
        let afError = AFError.sessionTaskFailed(error: urlError)
        
        let loginError = LoginError.fromAFError(afError)
        
        guard case .shipNotRunning = loginError else {
            XCTFail("LoginError should have been .shipNotRunning")
            return
        }
    }

    func test_fromAFError_whenBadGateway_returnsInvalidHost() throws {
        // You get this when the host doesn't respond
        let afError = AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 502))
        
        let loginError = LoginError.fromAFError(afError)
        
        guard case .invalidHost = loginError else {
            XCTFail("LoginError should have been .invalidHost")
            return
        }
    }
    
    func test_fromAFError_whenLoginEndpointNotFound_returnsInvalidHost() throws {
        // You get this when it can't find "http://hostname/~/login"
        let afError = AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 404))
        
        let loginError = LoginError.fromAFError(afError)
        
        guard case .invalidHost = loginError else {
            XCTFail("LoginError should have been .invalidHost")
            return
        }
    }
    
    func test_fromAFError_whenHTTPRequired_returnsHTTPSRequired() throws {
        // You get this from your ship it requires HTTPS and you're connecting
        // over HTTP
        let urlError = URLError(URLError.Code.appTransportSecurityRequiresSecureConnection)

        let afError = AFError.sessionTaskFailed(error: urlError)
        
        let loginError = LoginError.fromAFError(afError)
        
        guard case .httpsRequired = loginError else {
            XCTFail("LoginError should have been .httpsRequired")
            return
        }
    }
    
    func test_fromAFError_whenCodeIsBad_returnsLoginFailed() throws {
        // You get this from your ship when your actual login fails
        let afError = AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 400))
        
        let loginError = LoginError.fromAFError(afError)
        
        guard case .badCode = loginError else {
            XCTFail("LoginError should have been .badCode")
            return
        }
    }
}
