import XCTest
@testable import NChallenge

final class ShortenedURLRepositoryTests: XCTestCase {
    
    var sut: ShortenedURLRepository!
    
    override func setUp() {
        super.setUp()
        sut = ShortenedURLRepository()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Save Tests
    
    func testSave_WithValidURL_ShouldStoreURL() async {
        // Given
        let shortenedURL = ShortenedURL(
            alias: "abc123",
            originalURL: "https://example.com",
            shortURL: "https://short.ly/abc123"
        )
        
        // When
        await sut.save(shortenedURL)
        
        // Then
        let allURLs = await sut.getAll()
        XCTAssertEqual(allURLs.count, 1)
        XCTAssertEqual(allURLs.first?.alias, "abc123")
        XCTAssertEqual(allURLs.first?.originalURL, "https://example.com")
        XCTAssertEqual(allURLs.first?.shortURL, "https://short.ly/abc123")
    }
    
    func testSave_MultipleURLs_ShouldStoreAll() async {
        // Given
        let url1 = ShortenedURL(
            alias: "abc123",
            originalURL: "https://example.com",
            shortURL: "https://short.ly/abc123"
        )
        let url2 = ShortenedURL(
            alias: "def456",
            originalURL: "https://google.com",
            shortURL: "https://short.ly/def456"
        )
        
        // When
        await sut.save(url1)
        await sut.save(url2)
        
        // Then
        let allURLs = await sut.getAll()
        XCTAssertEqual(allURLs.count, 2)
        XCTAssertTrue(allURLs.contains { $0.alias == "abc123" })
        XCTAssertTrue(allURLs.contains { $0.alias == "def456" })
    }
    
    // MARK: - Get All Tests
    
    func testGetAll_WithEmptyRepository_ShouldReturnEmptyArray() async {
        // When
        let allURLs = await sut.getAll()
        
        // Then
        XCTAssertTrue(allURLs.isEmpty)
    }
    
    func testGetAll_WithStoredURLs_ShouldReturnAllURLs() async {
        // Given
        let url1 = ShortenedURL(
            alias: "abc123",
            originalURL: "https://example.com",
            shortURL: "https://short.ly/abc123"
        )
        let url2 = ShortenedURL(
            alias: "def456",
            originalURL: "https://google.com",
            shortURL: "https://short.ly/def456"
        )
        
        await sut.save(url1)
        await sut.save(url2)
        
        // When
        let allURLs = await sut.getAll()
        
        // Then
        XCTAssertEqual(allURLs.count, 2)
    }
    
    // MARK: - Is URL Already Cached Tests
    
    func testIsURLAlreadyCached_WithExistingURL_ShouldReturnTrue() async {
        // Given
        let url = "https://example.com"
        let shortenedURL = ShortenedURL(
            alias: "abc123",
            originalURL: url,
            shortURL: "https://short.ly/abc123"
        )
        await sut.save(shortenedURL)
        
        // When
        let isCached = await sut.isURLAlreadyCached(url)
        
        // Then
        XCTAssertTrue(isCached)
    }
    
    func testIsURLAlreadyCached_WithNonExistingURL_ShouldReturnFalse() async {
        // Given
        let existingURL = "https://example.com"
        let nonExistingURL = "https://google.com"
        let shortenedURL = ShortenedURL(
            alias: "abc123",
            originalURL: existingURL,
            shortURL: "https://short.ly/abc123"
        )
        await sut.save(shortenedURL)
        
        // When
        let isCached = await sut.isURLAlreadyCached(nonExistingURL)
        
        // Then
        XCTAssertFalse(isCached)
    }
    
    func testIsURLAlreadyCached_WithEmptyRepository_ShouldReturnFalse() async {
        // Given
        let url = "https://example.com"
        
        // When
        let isCached = await sut.isURLAlreadyCached(url)
        
        // Then
        XCTAssertFalse(isCached)
    }
    
    // MARK: - Get Cached URL Tests
    
    func testGetCachedURL_WithExistingURL_ShouldReturnURL() async {
        // Given
        let originalURL = "https://example.com"
        let shortenedURL = ShortenedURL(
            alias: "abc123",
            originalURL: originalURL,
            shortURL: "https://short.ly/abc123"
        )
        await sut.save(shortenedURL)
        
        // When
        let cachedURL = await sut.getCachedURL(for: originalURL)
        
        // Then
        XCTAssertNotNil(cachedURL)
        XCTAssertEqual(cachedURL?.alias, "abc123")
        XCTAssertEqual(cachedURL?.originalURL, originalURL)
        XCTAssertEqual(cachedURL?.shortURL, "https://short.ly/abc123")
    }
    
    func testGetCachedURL_WithNonExistingURL_ShouldReturnNil() async {
        // Given
        let existingURL = "https://example.com"
        let nonExistingURL = "https://google.com"
        let shortenedURL = ShortenedURL(
            alias: "abc123",
            originalURL: existingURL,
            shortURL: "https://short.ly/abc123"
        )
        await sut.save(shortenedURL)
        
        // When
        let cachedURL = await sut.getCachedURL(for: nonExistingURL)
        
        // Then
        XCTAssertNil(cachedURL)
    }
    
    func testGetCachedURL_WithEmptyRepository_ShouldReturnNil() async {
        // Given
        let url = "https://example.com"
        
        // When
        let cachedURL = await sut.getCachedURL(for: url)
        
        // Then
        XCTAssertNil(cachedURL)
    }
}

