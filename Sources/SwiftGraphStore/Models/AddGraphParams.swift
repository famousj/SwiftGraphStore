import Foundation

struct AddGraphParams: Encodable, Equatable {
    let resource: Resource
    let graph: [String: String]
    @NullCodable var mark: String?
    let overwrite: Bool
    
}
