import Foundation
import UrsusHTTP
import BigInt

extension Ship {
    public static var testInstance: Ship {

        return Ship(atom: Atom.testInstance)
    }
}
