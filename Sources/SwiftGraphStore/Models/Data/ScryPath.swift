import Foundation
import UrsusHTTP

enum ScryPath {
    case keys
    case graph(resource: Resource)
    case rootNodes(resource: Resource)
    case node(resource: Resource, index: Index, mode: ScryMode)
    
    var asPath: Path {
        switch self {
        case .keys:
            return "/keys"
        case .graph(let resource):
            return graphPath(resource: resource)
        case .rootNodes(let resource):
            return graphPath(resource: resource) + "/subset/lone/~/~"
        case let .node(resource, index, mode):
            return graphPath(resource: resource) + "/node/index/" + mode.rawValue + index.pathWithSeparators
        }
    }
    
    private func graphPath(resource: Resource) -> Path {
        "/graph/\(resource.ship)/\(resource.name)"
    }
}
