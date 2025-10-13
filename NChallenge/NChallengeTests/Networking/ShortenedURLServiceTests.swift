import XCTest
@testable import NChallenge

final class ShortenedURLServiceTests: XCTestCase {
    
    private let networkManagerSpy = NetworkManagerSpy()
    
    private lazy var sut: ShortenedURLService = {
        let service = ShortenedURLService(networkManager: networkManagerSpy)
        return service
    }()

    func testShorten_WithValidURL_ShouldReturnShortenedURL() async throws {
        let urlString = "https://example.com"
        let expectedResponse = URLShortenedResponseDTO(
            alias: "abc123",
            links: LinksDTO(selfURL: urlString, short: "https://short.ly/abc123")
        )
        networkManagerSpy.responseToBeReturned = expectedResponse
        
        let result = try await sut.shorten(urlString: urlString)
        
        XCTAssertEqual(result.alias, "abc123")
        XCTAssertEqual(result.links.selfURL, urlString)
        XCTAssertEqual(result.links.short, "https://short.ly/abc123")
        XCTAssertEqual(networkManagerSpy.lastURL, APIResource.baseURL)
        XCTAssertEqual(networkManagerSpy.lastMethod, HTTPMethod.POST)
        XCTAssertNotNil(networkManagerSpy.lastBody as? URLShortenRequest)
    }
    
    func testShorten_WithNetworkError_ShouldThrowError() async {
        let urlString = "https://example.com"
        let expectedError = NetworkError.invalidResponse(statusCode: 500)
        networkManagerSpy.errorToBeReturned = expectedError
        
        do {
            _ = try await sut.shorten(urlString: urlString)
            XCTFail("Should throw network error")
        } catch {
            XCTAssertEqual(error as? NetworkError, expectedError)
        }
    }
    
    func testShorten_WithDecodingError_ShouldThrowError() async {
        let urlString = "https://example.com"
        let expectedError = NetworkError.invalidResponse(statusCode: 200)
        networkManagerSpy.errorToBeReturned = expectedError
  
        do {
            _ = try await sut.shorten(urlString: urlString)
            XCTFail("Should throw network error")
        } catch {
            XCTAssertEqual(error as? NetworkError, expectedError)
        }
    }
}

