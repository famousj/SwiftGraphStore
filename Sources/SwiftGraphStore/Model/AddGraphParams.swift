import Foundation

struct AddGraphParams: Encodable {
    let resource: Resource
    let graph: [String: String]
    @NullCodable var mark: String?
    let overwrite: Bool
    
}
