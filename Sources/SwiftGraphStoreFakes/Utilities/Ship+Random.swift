import Foundation
import UrsusHTTP

extension Ship {
    public static var testInstance: Ship {

        return Ship(atom: Atom.testInstance)
    }
}
