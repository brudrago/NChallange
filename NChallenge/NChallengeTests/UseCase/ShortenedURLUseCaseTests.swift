import XCTest
@testable import NChallenge

final class ShortenedURLUseCaseTests: XCTestCase {
    
    private let serviceSpy = ShortenedURLServiceSpy()
    private let mapperSpy = ShortenedURLMapperSpy()
    
    private lazy var sut = ShortenedURLUseCase(
        service: serviceSpy,
        mapper: mapperSpy
    )
    
    func testShorten_WithValidURL_ShouldReturnMappedResponse() async throws {
        let urlString = "https://example.com"
        let dtoResponse = URLShortenedResponseDTO.fixture()
        let expectedModel = ShortenedURL.fixture(originalURL: "https://example.com", shortURL: "https://tinyurl.com/y2y77777")
        
        serviceSpy.responseToBeReturned = dtoResponse
        mapperSpy.responseToBeReturned = expectedModel
        
        let result = try await sut.shorten(urlString: urlString)
        
        XCTAssertEqual(result.alias, "123")
        XCTAssertEqual(result.originalURL, urlString)
        XCTAssertEqual(result.shortURL, "https://tinyurl.com/y2y77777")
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
}



