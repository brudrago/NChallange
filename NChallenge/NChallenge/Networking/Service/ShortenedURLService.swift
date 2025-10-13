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
        let response = try await networkManager.request(
            url: APIResource.baseURL,
            method: .POST,
            body: request,
            responseType: URLShortenedResponseDTO.self
        )
        return response
    }
}
