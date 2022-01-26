import Foundation
import UrsusHTTP
import BigInt

extension Ship {
    public static var random: Ship {
        let randomAtom = UInt.random(in: 0...0xFFFFFFFF)
        let atom = Atom(String(randomAtom))!
        return Ship(atom: atom)
    }
}
