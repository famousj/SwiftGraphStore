import Foundation
import UrsusHTTP
import BigInt

extension Ship {
    static var random: Ship {
        let randomAtom = UInt.random(in: 0...0xFFFFFFFF)
        let bigUInt = BigUInt(String(randomAtom))!
        return Ship(atom: bigUInt)
    }
}
