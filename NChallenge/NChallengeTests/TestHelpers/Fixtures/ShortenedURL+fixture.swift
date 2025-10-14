@testable import NChallenge

extension ShortenedURL {
    static func fixture(
        alias: String = "123",
        originalURL: String = "https://www.google.com",
        shortURL: String = "https://nchallenge.app/123",
    ) -> ShortenedURL {
        return .init(
            alias: alias,
            originalURL: originalURL,
            shortURL: shortURL
        )
    }
}
