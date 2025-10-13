import Foundation

enum NetworkError: Error, Equatable {
    case invalidResponse(statusCode: Int)
    case invalidURL
    case encodingError
}

protocol NetworkManagerProtocol {
    func request<T: Decodable>(
        url: String,
        method: HTTPMethod,
        body: Encodable?,
        responseType: T.Type
    ) async throws -> T
    
}

struct NetworkManager: NetworkManagerProtocol {
    init() {}
    
    func request<T: Decodable>(
        url: String,
        method: HTTPMethod,
        body: Encodable?,
        responseType: T.Type
    ) async throws -> T {
        let (data, _) = try await request(url: url, method: method, body: body)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    private func request(
        url: String,
        method: HTTPMethod,
        body: Encodable?
    ) async throws -> (Data, URLResponse) {
        guard let url = URL(string: url) else { 
            throw NetworkError.invalidURL 
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            let jsonData = try JSONEncoder().encode(body)
            request.httpBody = jsonData
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        guard statusCode == 200 || statusCode == 201 else {
            throw NetworkError.invalidResponse(statusCode: statusCode ?? -1)
        }
        
        return (data, response)
    }
}
