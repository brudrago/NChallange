import Foundation

// MARK: - Cache Manager Protocol
protocol ShortenedURLCacheManagerProtocol {
    func cacheShortenedURL(_ url: ShortenedURL)
    func getCachedShortenedURLs() -> [ShortenedURL]
    func isURLAlreadyCached(_ originalURL: String) -> Bool
    func getCachedURL(for originalURL: String) -> ShortenedURL?
    func clearCache()
}

// MARK: - Cache Manager Implementation using URLCache
final class ShortenedURLCacheManager: ShortenedURLCacheManagerProtocol {
    private let cacheKey = "ShortenedURLs"
    private let baseURL = URL(string: "cache://shortened-urls")!
    
    init() {}
    
    func cacheShortenedURL(_ url: ShortenedURL) {
        var cachedURLs = getCachedShortenedURLs()
        
        // Remove se já existe (para evitar duplicatas)
        cachedURLs.removeAll { $0.originalURL == url.originalURL }
        
        // Adiciona a nova URL
        cachedURLs.append(url)
        
        // Salva no URLCache
        saveToURLCache(cachedURLs)
    }
    
    func getCachedShortenedURLs() -> [ShortenedURL] {
        guard let data = getCachedData(),
              let urls = try? JSONDecoder().decode([ShortenedURL].self, from: data) else {
            return []
        }
        return urls
    }
    
    func isURLAlreadyCached(_ originalURL: String) -> Bool {
        let cachedURLs = getCachedShortenedURLs()
        return cachedURLs.contains { $0.originalURL == originalURL }
    }
    
    func getCachedURL(for originalURL: String) -> ShortenedURL? {
        let cachedURLs = getCachedShortenedURLs()
        return cachedURLs.first { $0.originalURL == originalURL }
    }
    
    func clearCache() {
        let request = URLRequest(url: baseURL)
        URLCache.shared.removeCachedResponse(for: request)
    }
    
    // MARK: - Private Methods
    
    private func saveToURLCache(_ urls: [ShortenedURL]) {
        do {
            let data = try JSONEncoder().encode(urls)
            let response = URLResponse(url: baseURL, mimeType: "application/json", expectedContentLength: data.count, textEncodingName: nil)
            let cachedResponse = CachedURLResponse(response: response, data: data)
            
            let request = URLRequest(url: baseURL)
            URLCache.shared.storeCachedResponse(cachedResponse, for: request)
        } catch {
            print("❌ Error saving to URLCache: \(error)")
        }
    }
    
    private func getCachedData() -> Data? {
        let request = URLRequest(url: baseURL)
        guard let cachedResponse = URLCache.shared.cachedResponse(for: request) else {
            return nil
        }
        return cachedResponse.data
    }
}
