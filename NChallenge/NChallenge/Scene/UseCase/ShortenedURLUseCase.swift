import Foundation

protocol ShortenedURLUseCaseProtocol {
    func shorten(urlString: String) async throws -> ShortenedURL
}

struct ShortenedURLUseCase: ShortenedURLUseCaseProtocol {
    private let service: ShortenedURLServiceProtocol
    private let mapper: ShortenedURLMapProtocol
    
    init(
        service: ShortenedURLServiceProtocol,
        mapper: ShortenedURLMapProtocol
    ) {
        self.service = service
        self.mapper = mapper
    }
    
    func shorten(urlString: String) async throws -> ShortenedURL {
        do {
            let response = try await service.shorten(urlString: urlString)
            let mappedResponse = mapper.map(response)
            print("✅ Interactor received response: \(response.alias)")
            return mappedResponse
            
        } catch {
            throw error
        }
    }
}
