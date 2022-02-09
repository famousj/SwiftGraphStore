import Foundation
import UrsusHTTP

enum ScryPath {
    case keys
    case graph(resource: Resource)
    case rootNodes(resource: Resource)
    case node(resource: Resource, index: Index, mode: ScryMode)
    case children(resource: Resource, index: Index, mode: ScryMode)
    
    var asPath: Path {
        switch self {
        case .keys:
            return "/keys"
        case .graph(let resource):
            return graphPath(resource: resource)
        case .rootNodes(let resource):
            return childrenPath(resource: resource,
                                mode: .excludeDescendants,
                                indexPath: nil)
        case let .node(resource, index, mode):
            return graphPath(resource: resource) + "/node/index/" + mode.rawValue + index.pathWithSeparators
        case let .children(resource, index, mode):
            return childrenPath(resource: resource,
                                mode: mode,
                                indexPath: index.pathWithSeparators)
        }
    }
    
    private func graphPath(resource: Resource) -> Path {
        "/graph/\(resource.ship)/\(resource.name)"
    }
    
    private func childrenPath(resource: Resource,
                              mode: ScryMode,
                              indexPath: Path?) -> Path {
        
        let suffix = (indexPath != nil) ? indexPath! : ""
        return graphPath(resource: resource) + "/node/children/" + mode.rawValue + "/~/~" + suffix
    }
}
