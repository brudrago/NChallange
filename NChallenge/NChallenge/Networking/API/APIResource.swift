import Foundation

struct APIResource {
    
    static let baseURL: String = "https://url-shortener-server.onrender.com/api/alias"
}

enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
}
