import Foundation
import SwiftGraphStore

extension ScryMode: CaseIterable {
    public static var allCases: [ScryMode] {
        [.includeDescendants, .excludeDescendants]
    }
}

extension ScryMode {
    public static var random: ScryMode {
        allCases.randomElement()!
    }
}
