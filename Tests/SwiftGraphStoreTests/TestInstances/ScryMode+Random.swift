import Foundation
import SwiftGraphStore

extension ScryMode: CaseIterable {
    public static var allCases: [ScryMode] {
        [.includeDescendants, .excludeDescendants]
    }
}

extension ScryMode {
    static var random: ScryMode {
        allCases.randomElement()!
    }
}
