import Foundation
@testable import SwiftGraphStore

extension Atom {
    public static var testInstance: Atom {
        let randomAtom = UInt.random(in: 0...0xFFFFFFFF)
        return Atom(String(randomAtom))!
    }
}
