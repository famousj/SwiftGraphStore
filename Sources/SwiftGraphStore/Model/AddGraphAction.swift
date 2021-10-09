import Foundation

struct AddGraphAction: Encodable {
    enum CodingKeys: String, CodingKey {
        case addGraph = "add-graph"
    }
    
    let addGraph: AddGraphParams
}
