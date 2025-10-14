@testable import NChallenge

final class ShortenedURLRepositorySpy: ShortenedURLRepositoryProtocol {
    private(set) var saveCalled = false
    private(set) var savedURL: ShortenedURL?
    
    func save(_ shortenedURL: ShortenedURL) async {
        saveCalled = true
        savedURL = shortenedURL
    }
    
    private(set) var getAllCalled = false
    var getAllResult: [ShortenedURL] = []
    
    func getAll() async -> [ShortenedURL] {
        getAllCalled = true
        return getAllResult
    }
    
    private(set) var isURLAlreadyCachedCalled = false
    var isURLAlreadyCachedResult = false
    
    func isURLAlreadyCached(_ originalURL: String) async -> Bool {
        isURLAlreadyCachedCalled = true
        lastCheckedURL = originalURL
        return isURLAlreadyCachedResult
    }
    
    private(set) var lastCheckedURL: String?
    
    func getCachedURL(for originalURL: String) async -> ShortenedURL? {
        return nil
    }
}
