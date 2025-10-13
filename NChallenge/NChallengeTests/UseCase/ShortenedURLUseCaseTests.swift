import XCTest
@testable import NChallenge

final class ShortenedURLUseCaseTests: XCTestCase {
    
    private let serviceSpy = ShortenedURLServiceSpy()
    private let mapperSpy = ShortenedURLMapperSpy()
    
    private lazy var sut = ShortenedURLUseCase(
        service: serviceSpy,
        mapper: mapperSpy
    )
    
    
    // MARK: - Success Tests
    
    func testShorten_WithValidURL_ShouldReturnMappedResponse() async throws {
        let urlString = TestData.validURL
        let dtoResponse = TestData.sampleURLShortenedResponseDTO
        let expectedModel = TestData.sampleShortenedURL
        
        serviceSpy.responseToBeReturned = dtoResponse
        mapperSpy.responseToBeReturned = expectedModel
        
        let result = try await sut.shorten(urlString: urlString)
        
        XCTAssertEqual(result.alias, "abc123")
        XCTAssertEqual(result.originalURL, urlString)
        XCTAssertEqual(result.shortURL, "https://short.ly/abc123")
        XCTAssertEqual(serviceSpy.lastURLString, urlString)
        XCTAssertEqual(mapperSpy.lastDTO?.alias, dtoResponse.alias)
    }
    
    func testShorten_WithServiceError_ShouldThrowError() async {
        let urlString = "https://example.com"
        let expectedError = NetworkError.invalidResponse(statusCode: 500)
        serviceSpy.errorToBeReturned = expectedError

        do {
            _ = try await sut.shorten(urlString: urlString)
            XCTFail("Should throw service error")
        } catch {
            XCTAssertEqual(error as? NetworkError, expectedError)
        }
    }
    
    func testShorten_WithMapperError_ShouldReturnErrorResponse() async throws {
        let urlString = "https://example.com"
        let dtoResponse = URLShortenedResponseDTO(
            alias: "abc123",
            links: LinksDTO(selfURL: urlString, short: "https://short.ly/abc123")
        )
        
        serviceSpy.responseToBeReturned = dtoResponse
        mapperSpy.errorToBeReturned = NSError(domain: "TestError", code: 1, userInfo: nil)
        
        let result = try await sut.shorten(urlString: urlString)
 
        XCTAssertEqual(mapperSpy.lastDTO?.alias, dtoResponse.alias)
        XCTAssertEqual(mapperSpy.mapCallCount, 1)
        XCTAssertEqual(result.alias, "ERROR")
        XCTAssertEqual(result.originalURL, "ERROR")
        XCTAssertEqual(result.shortURL, "ERROR")
    }
}



