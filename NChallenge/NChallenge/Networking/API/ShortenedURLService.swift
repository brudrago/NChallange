import Foundation

protocol ShortenedURLServiceProtocol {
    func shorten(urlString: String) async throws -> URLShortenedResponse
}

struct ShortenedURLService: ShortenedURLServiceProtocol {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func shorten(urlString: String) async throws -> URLShortenedResponse {
        let request = URLShortenRequest(url: urlString)
        let result = try await networkManager.post(APIResource.baseURL, body: request)
        
        switch result {
        case .success((let data, _)):
            let response = try JSONDecoder().decode(URLShortenedResponse.self, from: data)
            print("✅ Success: \(response)")
            print("✅ Success - Alias: \(response.alias)")
            print("✅ Success - Short URL: \(response.links.short)")
            //mapear a response para outro objeto em um useCase e injetar esse useCase no interactor
            return response
        case .failure(let error):
            print("❌ Error: \(error)")
            throw error
        }
    }
    
    
}
