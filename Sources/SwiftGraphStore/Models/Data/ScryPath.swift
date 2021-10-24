import Foundation
import UrsusHTTP

enum ScryPath {
    case keys
    case graph(resource: Resource)
    case rootNodes(resource: Resource)
    
    var asPath: Path {
        switch self {
        case .keys:
            return "/keys"
        case .graph(let resource):
            return graphPath(resource: resource)
        case .rootNodes(let resource):
            return graphPath(resource: resource) + "/subset/lone/~/~"
        }
    }
    
    private func graphPath(resource: Resource) -> Path {
        "/graph/\(resource.ship)/\(resource.name)"
    }
}
