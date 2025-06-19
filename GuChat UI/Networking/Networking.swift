import Foundation

struct APIResponse: Decodable{
    let token: String?
    let message: String?
    let error: String?
}

enum APIError: Error, LocalizedError{
    case invaliUrl
    case seerverError(String)
    case decodingError
    case unknown
    
    var errorDescription: String?{
        switch self{
        case .invaliUrl:
            return "Invalid URL"
        case .seerverError(let message):
            return message
        case .decodingError:
            return "Decoding Error"
        case .unknown:
            return "Unknown Error"
        }
    }
}
