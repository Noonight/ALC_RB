
import Foundation
import Alamofire

struct Announce: Codable {
    
    var id: String
    
    var content: String? = nil
    var tourney: IdRefObjectWrapper<Tourney>? = nil
    
    var createdAt: Date? = nil
    var updatedAt: Date? = nil
    var v: Int? = nil
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        
        case content
        case tourney
        
        case createdAt
        case updatedAt
        
        case v = "__v"
    }
}
