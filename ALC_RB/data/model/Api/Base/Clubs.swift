// To parse the JSON, add this file to your project and do:
//
//   let clubs = try [Club](json)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseClubs { response in
//     if let clubs = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

struct Club: Codable {
    
    var id: String
    
    var region: IdRefObjectWrapper<RegionMy>? = nil
    
    var name: String? = nil
    var logo: String? = nil
    var info: String? = nil
    
    var owner: IdRefObjectWrapper<Person>? = nil
    
    var addLogo: String? = nil
    var addInfo: String? = nil

    var v: String? = nil
    
    init() {
        id = ""
        region = nil
        name = nil
        logo = nil
        info = nil
        owner = nil
        addLogo = nil
        addInfo = nil
        v = nil
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        
        case region
        
        case name
        case logo
        case info
        
        case owner
        
        case addLogo
        case addInfo
        
        case v = "__v"
    }
}

// MARK: - Alamofire response handlers

extension DataRequest {
    fileprivate func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            guard error == nil else { return .failure(error!) }
            
            guard let data = data else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }
            
            return Result { try ISO8601Decoder.getDecoder().decode(T.self, from: data) }
        }
    }
    
    @discardableResult
    fileprivate func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseClubs(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<[Club]>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
