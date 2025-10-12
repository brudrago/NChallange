import Foundation

enum NetworkError: Error {
    case invalidResponse(statusCode: Int)
    case invalidURL
    case encodingError
}

protocol NetworkManagerProtocol {
    func post<T: Encodable>(_ urlString: String, body: T) async throws -> Result<(Data, URLResponse), Error>
}

final class NetworkManager: NetworkManagerProtocol {
    init() {}
    
    func post<T: Encodable>(_ urlString: String, body: T) async throws -> Result<(Data, URLResponse), Error> {
        guard let url = URL(string: urlString) else { return .failure(NetworkError.invalidURL) }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(body)
            request.httpBody = jsonData
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            
            guard statusCode == 200 || statusCode == 201 else {
                throw NetworkError.invalidResponse(statusCode: statusCode ?? -1)
            }
            
            return .success((data, response))
            
        } catch let error {
            print("👻 DEBUG: POST error -> \(error.localizedDescription)")
            return .failure(error)
        }
    }
}
