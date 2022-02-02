import Foundation

extension Graph {
    public func asStringDictionary() -> [String: Node] {
        var dict = [String: Node]()
        forEach { (key, value) in
            dict[key.description] = value
        }
        return dict
    }
}

extension Dictionary where Key == String, Value == Node {
    public func asGraph() throws -> Graph {
        var graph = Graph()
        try forEach { (key, value) in
            guard let atomKey = Atom(key) else {
                throw NSError(domain: "", code: 0)
            }
            graph[atomKey] = value
        }
        return graph
    }
}
