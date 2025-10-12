import Foundation

protocol ShortenedURLRepositoryProtocol {
    func save(_ shortenedURL: ShortenedURL)
    func getAll() -> [ShortenedURL]
    func getCachedURL(for originalURL: String) -> ShortenedURL?
}


final class ShortenedURLRepository: ShortenedURLRepositoryProtocol {
    private let cacheManager: ShortenedURLCacheManagerProtocol
    
    init(cacheManager: ShortenedURLCacheManagerProtocol) {
        self.cacheManager = cacheManager
    }
    
    func save(_ shortenedURL: ShortenedURL) {
        cacheManager.cacheShortenedURL(shortenedURL)
    }
    
    func getAll() -> [ShortenedURL] {
        return cacheManager.getCachedShortenedURLs()
    }

    func getCachedURL(for originalURL: String) -> ShortenedURL? {
        return cacheManager.getCachedURL(for: originalURL)
    }
}
