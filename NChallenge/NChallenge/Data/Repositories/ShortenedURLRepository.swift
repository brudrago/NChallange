import Foundation

protocol ShortenedURLRepositoryProtocol {
    func save(_ shortenedURL: ShortenedURL) async
    func getAll() async -> [ShortenedURL]
    func isURLAlreadyCached(_ originalURL: String) async -> Bool
    func getCachedURL(for originalURL: String) async -> ShortenedURL?
}

actor ShortenedURLRepository: ShortenedURLRepositoryProtocol {
    private var shortenedURLs: [ShortenedURL] = []
    
    func save(_ shortenedURL: ShortenedURL) {
        shortenedURLs.append(shortenedURL)
    }
    
    func getAll() -> [ShortenedURL] {
        return shortenedURLs
    }
    
    func isURLAlreadyCached(_ originalURL: String) -> Bool {
        return shortenedURLs.contains { $0.originalURL == originalURL }
    }
    
    func getCachedURL(for originalURL: String) -> ShortenedURL? {
        return shortenedURLs.first { $0.originalURL == originalURL }
    }
}
