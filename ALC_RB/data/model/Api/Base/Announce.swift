
import Foundation
import Alamofire

struct Announce: Codable {
    var _id: String?
    var date: Date?
    var content: String?
    var tourney: String?
    var createdAt: Date?
    var updatedAt: Date?
    var __v: Int?
}

extension DataRequest {
    
    fileprivate func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
            return DataResponseSerializer { _, response, data, error in
                guard error == nil else { return .failure(error!) }
    
                guard let data = data else {
                    return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
                }
    
                let isoDecoder = ISO8601Decoder.getDecoder()
                
                return Result { try isoDecoder.decode(T.self, from: data) }
            }
        }
    
        @discardableResult
        fileprivate func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
            return response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
        }
    
    @discardableResult
        func responseAnnounce(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<[Announce]>) -> Void) -> Self {
            return responseDecodable(queue: queue, completionHandler: completionHandler)
        }
}
