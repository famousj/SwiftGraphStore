import Foundation
import BigInt

// TODO: allow this index to be based off a @da, instead of a swift `Date`
public struct Index {
    public let atoms: [Atom]

    public init(atoms: [Atom]) {
        self.atoms = atoms
    }
}

extension Index: RawRepresentable {
    public var rawValue: String {
        path
    }
    
    public init?(rawValue: String) {
        guard let stringValues = Self.atomsFromString(rawValue) else {
            return nil
        }
        atoms = stringValues
    }
}

extension Index {
    public init(date: Date = .now) {
        self.init(atoms: [Atom(date.timeIntervalSinceReferenceDate * 1000)])
    }
}

extension Index {
    public init?(_ string: String) {
        self.init(rawValue: string)
    }
    
    public var path: String {
        makePath(String.init)
    }
    
    public var pathWithSeparators: String {
        makePath { atom in
            String(atom)
                .split(every: 3)
                .joined(separator: ".")
        }
    }
    
    private func makePath(_ stringCreator: (Atom) -> String) -> String {
        "/" + atoms.map(stringCreator).joined(separator: "/")
    }
    
    private static func atomsFromString(_ string: String) -> [Atom]? {
        let values = string.split(separator: "/")
            .map { $0.split(separator: ".").joined() }
            .map { Atom($0) }
        
        if values.contains(where: {$0 == nil }) {
            return nil
        } else {
            return values.compactMap { $0 }
        }
    }
    
    public static func convertStringDictionary<T>(_ dict: [String: T]) throws -> [Index: T] {
        var newDict = [Index: T]()
        try dict.forEach { (key, value) in
            guard let indexKey = Index(key) else {
                throw NSError()
            }
            newDict[indexKey] = value
        }
        return newDict
    }
    
    public static func convertIndexDictionary<T>(_ dict: [Index: T]) -> [String: T] {
        var newDict = [String: T]()
        dict.forEach { (key, value) in
            newDict[key.path] = value
        }
        return newDict
    }
}

extension Index: Codable {}

extension Index: Equatable {}

extension Index: Hashable {
    public func hash(into hasher: inout Hasher) {
        atoms.forEach { hasher.combine($0) }
    }
}

extension Index: Comparable {
    public static func < (lhs: Index, rhs: Index) -> Bool {
        for (lhs, rhs) in zip(lhs.atoms, rhs.atoms) {
            if lhs < rhs {
                return true
            } else if rhs < lhs {
                return false
            }
        }
        
        return false
    }
}

extension Index: CustomStringConvertible {
    public var description: String {
        path
    }
}

fileprivate extension String {
    func split(every: Int) -> [String] {
        var result = [String]()
        for i in stride(from: 0, to: self.count, by: every) {
            let endIndex = self.index(self.endIndex, offsetBy: -i)
            let startIndex = self.index(endIndex, offsetBy: -every, limitedBy: self.startIndex) ?? self.startIndex
            result.insert(String(self[startIndex..<endIndex]), at: 0)
        }
        return result
    }
}
