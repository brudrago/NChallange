import Foundation

protocol ShortenedURLServiceProtocol {
    func shorten(urlString: String) async throws -> URLShortenedResponseDTO
}

struct ShortenedURLService: ShortenedURLServiceProtocol {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func shorten(urlString: String) async throws -> URLShortenedResponseDTO {
        let request = URLShortenRequest(url: urlString)
        let result = try await networkManager.post(APIResource.baseURL, body: request)
        
        switch result {
        case .success((let data, _)):
            let response = try JSONDecoder().decode(URLShortenedResponseDTO.self, from: data)
            return response
        case .failure(let error):
            print("❌ Error: \(error)")
            throw error
        }
    }
    
    
}
