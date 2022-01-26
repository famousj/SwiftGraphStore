import Foundation

public typealias Graph = [Atom: Node]

extension Graph {
    
    // TODO: Test this
    // TODO: Add this to a protocol or something
    public static func convertStringDictionary(_ dict: [String: Node]) throws -> Graph {
        var newDict = Graph()
        try dict.forEach { (key, value) in
            guard let atomKey = Atom(key) else {
                throw NSError()
            }
            newDict[atomKey] = value
        }
        return newDict
    }
    
    public static func convertGraphDictionary<T>(_ dict: [Atom: T]) -> [String: T] {
        var newDict = [String: T]()
        dict.forEach { (key, value) in
            newDict[key.description] = value
        }
        return newDict
    }
}
