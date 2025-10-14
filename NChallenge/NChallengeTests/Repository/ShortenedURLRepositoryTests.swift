import XCTest
@testable import NChallenge

final class ShortenedURLRepositoryTests: XCTestCase {
    
    private let sut = ShortenedURLRepository()
    
    // MARK: - Save Tests
    
    func testSave_WithValidURL_ShouldStoreURL() async {
        let shortenedURL = ShortenedURL.fixture(
            alias: "abc123",
            originalURL: "https://example.com",
            shortURL: "https://short.ly/abc123"
        )
 
        await sut.save(shortenedURL)

        let allURLs = await sut.getAll()
        XCTAssertEqual(allURLs.count, 1)
        XCTAssertEqual(allURLs.first?.alias, "abc123")
        XCTAssertEqual(allURLs.first?.originalURL, "https://example.com")
        XCTAssertEqual(allURLs.first?.shortURL, "https://short.ly/abc123")
    }
    
    func testSave_MultipleURLs_ShouldStoreAll() async {
        let urlOne = ShortenedURL.fixture(
            alias: "abc123",
            originalURL: "https://example.com",
            shortURL: "https://short.ly/abc123"
        )
        
        let urlTwo = ShortenedURL.fixture(
            alias: "def456",
            originalURL: "https://google.com",
            shortURL: "https://short.ly/def45"
        )

        await sut.save(urlOne)
        await sut.save(urlTwo)
        
        // Then
        let allURLs = await sut.getAll()
        XCTAssertEqual(allURLs.count, 2)
        XCTAssertTrue(allURLs.contains { $0.alias == "abc123" })
        XCTAssertTrue(allURLs.contains { $0.alias == "def456" })
    }

    func testGetAll_WithEmptyRepository_ShouldReturnEmptyArray() async {
        let allURLs = await sut.getAll()

        XCTAssertTrue(allURLs.isEmpty)
    }
    
    func testGetAll_WithStoredURLs_ShouldReturnAllURLs() async {
        let urlOne = ShortenedURL.fixture(
            alias: "abc123",
            originalURL: "https://example.com",
            shortURL: "https://short.ly/abc123"
        )
        
        let urlTwo = ShortenedURL.fixture(
            alias: "def456",
            originalURL: "https://google.com",
            shortURL: "https://short.ly/def45"
        )

        await sut.save(urlOne)
        await sut.save(urlTwo)

        let allURLs = await sut.getAll()
        
        XCTAssertEqual(allURLs.count, 2)
    }

    func testIsURLAlreadyCached_WithExistingURL_ShouldReturnTrue() async {
        let url = "https://example.com"
        let shortenedURL = ShortenedURL.fixture(
            alias: "abc123",
            originalURL: url,
            shortURL: "https://short.ly/abc123"
        )
        await sut.save(shortenedURL)

        let isCached = await sut.isURLAlreadyCached(url)

        XCTAssertTrue(isCached)
    }
    
    func testIsURLAlreadyCached_WithNonExistingURL_ShouldReturnFalse() async {
        let existingURL = "https://example.com"
        let nonExistingURL = "https://google.com"
        let shortenedURL = ShortenedURL.fixture(
            alias: "abc123",
            originalURL: existingURL,
            shortURL: "https://short.ly/abc123"
        )
        await sut.save(shortenedURL)
        
        let isCached = await sut.isURLAlreadyCached(nonExistingURL)

        XCTAssertFalse(isCached)
    }
    
    func testIsURLAlreadyCached_WithEmptyRepository_ShouldReturnFalse() async {
        let url = "https://example.com"
        let isCached = await sut.isURLAlreadyCached(url)

        XCTAssertFalse(isCached)
    }

    func testGetCachedURL_WithExistingURL_ShouldReturnURL() async {
        let originalURL = "https://example.com"
        let shortenedURL = ShortenedURL.fixture(
            alias: "abc123",
            originalURL: originalURL,
            shortURL: "https://short.ly/abc123"
        )
        await sut.save(shortenedURL)
        
        let cachedURL = await sut.getCachedURL(for: originalURL)

        XCTAssertNotNil(cachedURL)
        XCTAssertEqual(cachedURL?.alias, "abc123")
        XCTAssertEqual(cachedURL?.originalURL, originalURL)
        XCTAssertEqual(cachedURL?.shortURL, "https://short.ly/abc123")
    }
    
    func testGetCachedURL_WithNonExistingURL_ShouldReturnNil() async {
        let existingURL = "https://example.com"
        let nonExistingURL = "https://google.com"
        let shortenedURL = ShortenedURL.fixture(
            alias: "abc123",
            originalURL: existingURL,
            shortURL: "https://short.ly/abc123"
        )
        await sut.save(shortenedURL)

        let cachedURL = await sut.getCachedURL(for: nonExistingURL)

        XCTAssertNil(cachedURL)
    }
    
    func testGetCachedURL_WithEmptyRepository_ShouldReturnNil() async {
        let url = "https://example.com"
        let cachedURL = await sut.getCachedURL(for: url)

        XCTAssertNil(cachedURL)
    }
}

