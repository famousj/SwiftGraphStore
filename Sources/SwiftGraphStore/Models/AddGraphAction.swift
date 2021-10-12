import Foundation

struct AddGraphAction: Encodable, Equatable {
    enum CodingKeys: String, CodingKey {
        case addGraph = "add-graph"
    }
    
    let addGraph: AddGraphParams
}
