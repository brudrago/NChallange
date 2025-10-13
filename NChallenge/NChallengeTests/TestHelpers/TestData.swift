import Foundation
@testable import NChallenge

// MARK: - Test Data Factory

struct TestData {
    
    // MARK: - Sample URLs
    
    static let validURL = "https://example.com"
    static let anotherValidURL = "https://google.com"
    static let invalidURL = "invalid-url"
    
    // MARK: - Sample ShortenedURL
    
    static let sampleShortenedURL = ShortenedURL(
        alias: "abc123",
        originalURL: "https://example.com",
        shortURL: "https://short.ly/abc123"
    )
    
    static let anotherShortenedURL = ShortenedURL(
        alias: "def456",
        originalURL: "https://google.com",
        shortURL: "https://short.ly/def456"
    )
    
    // MARK: - Sample DTOs
    
    static let sampleURLShortenedResponseDTO = URLShortenedResponseDTO(
        alias: "abc123",
        links: LinksDTO(
            selfURL: "https://example.com",
            short: "https://short.ly/abc123"
        )
    )
    
    static let anotherURLShortenedResponseDTO = URLShortenedResponseDTO(
        alias: "def456",
        links: LinksDTO(
            selfURL: "https://google.com",
            short: "https://short.ly/def456"
        )
    )
    
    // MARK: - Sample Request
    
    static let sampleURLShortenRequest = URLShortenRequest(url: "https://example.com")
    
    // MARK: - Sample Errors
    
    static let networkError = NetworkError.invalidResponse(statusCode: 500)
    static let invalidURLError = NetworkError.invalidURL
    static let customError = NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Test error"])
}
