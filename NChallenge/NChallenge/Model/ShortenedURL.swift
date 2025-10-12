import Foundation

// MARK: - Domain Model
struct ShortenedURL {
    let alias: String
    let originalURL: String
    let shortURL: String
    
    init(alias: String, originalURL: String, shortURL: String) {
        self.alias = alias
        self.originalURL = originalURL
        self.shortURL = shortURL
    }
}
