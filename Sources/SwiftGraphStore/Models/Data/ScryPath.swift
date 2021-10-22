import Foundation
import UrsusHTTP

enum ScryPath {
    case keys
    case graph(resource: Resource)
    
    // TODO: test this
    var asPath: Path {
        switch self {
        case .keys:
            return "/keys"
        case .graph(let resource):
            return "/graph/\(resource.ship)/\(resource.name)"
        }
    }
}
