import Foundation
import UrsusHTTP

enum ScryPath {
    case keys
    case graph(resource: Resource)
    case rootNodes(resource: Resource)
    // TODO: make an enum for Mode (%kith/%lone)
    case node(resource: Resource, index: Index)
    
    var asPath: Path {
        switch self {
        case .keys:
            return "/keys"
        case .graph(let resource):
            return graphPath(resource: resource)
        case .rootNodes(let resource):
            return graphPath(resource: resource) + "/subset/lone/~/~"
        case let .node(resource, index):
            return graphPath(resource: resource) + "/node/index/kith" + index.path
        }
    }
    
    private func graphPath(resource: Resource) -> Path {
        "/graph/\(resource.ship)/\(resource.name)"
    }
}
