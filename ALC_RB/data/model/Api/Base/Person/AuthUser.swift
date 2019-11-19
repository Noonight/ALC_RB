// To parse the JSON, add this file to your project and do:
//
//   let authUser = try AuthUser(json)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseAuthUser { response in
//     if let authUser = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

struct AuthUser: Codable {
    var person: Person
    var token: String
    
    enum CodingKeys: String, CodingKey {
        case person = "person"
        case token = "token"
    }
}


// MARK: Convenience initializers and mutators

extension AuthUser {
    
    init(coder aDecoder: NSCoder) {
        let person = aDecoder.decodeObject(forKey: "person") as! Person
        let token = aDecoder.decodeObject(forKey: "token") as! String
        
        self.init(person: person, token: token)
    }
    
    func encode(with aCoder: NSCoder){
        
        aCoder.encode(person, forKey: "person")
        aCoder.encode(token, forKey: "token")
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
    func responseAuthUser(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<AuthUser>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
