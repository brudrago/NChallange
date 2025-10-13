import XCTest
@testable import NChallenge

final class NetworkManagerTests: XCTestCase {
    
    private lazy var sut = NetworkManager()
    
    
    func testRequest_WithValidURL_ShouldReturnData() async throws {
        // Given
        let url = "https://httpbin.org/get"
        let method = HTTPMethod.GET
        let responseType = HTTPBinResponse.self
        
        // When
        let response = try await sut.request(
            url: url,
            method: method,
            body: nil,
            responseType: responseType
        )
        
        // Then
        XCTAssertNotNil(response)
        XCTAssertEqual(response.url, url)
    }
    
    func testRequest_WithPOST_ShouldReturnData() async throws {
        // Given
        let url = "https://httpbin.org/post"
        let method = HTTPMethod.POST
        let body = TestRequest(name: "Test", value: 123)
        let responseType = HTTPBinResponse.self
        
        // When
        let response = try await sut.request(
            url: url,
            method: method,
            body: body,
            responseType: responseType
        )
        
        // Then
        XCTAssertNotNil(response)
        XCTAssertEqual(response.url, url)
    }
    
    // MARK: - Error Tests
    
    func testRequest_WithInvalidURL_ShouldThrowInvalidURL() async {
        // Given
        let invalidURL = "invalid-url"
        let method = HTTPMethod.GET
        let responseType = HTTPBinResponse.self
        
        // When & Then
        do {
            _ = try await sut.request(
                url: invalidURL,
                method: method,
                body: nil,
                responseType: responseType
            )
            XCTFail("Should throw NetworkError.invalidURL")
        } catch NetworkError.invalidURL {
            // Expected error
        } catch {
            XCTFail("Should throw NetworkError.invalidURL, got: \(error)")
        }
    }
    
    func testRequest_WithNonExistentURL_ShouldThrowError() async {
        // Given
        let url = "https://non-existent-domain-12345.com"
        let method = HTTPMethod.GET
        let responseType = HTTPBinResponse.self
        
        // When & Then
        do {
            _ = try await sut.request(
                url: url,
                method: method,
                body: nil,
                responseType: responseType
            )
            XCTFail("Should throw network error")
        } catch {
            // Expected error for non-existent domain
            XCTAssertTrue(error is URLError)
        }
    }
    
    func testRequest_WithInvalidResponseType_ShouldThrowDecodingError() async {
        // Given
        let url = "https://httpbin.org/get"
        let method = HTTPMethod.GET
        let responseType = InvalidResponse.self
        
        // When & Then
        do {
            _ = try await sut.request(
                url: url,
                method: method,
                body: nil,
                responseType: responseType
            )
            XCTFail("Should throw decoding error")
        } catch {
            // Expected decoding error
            XCTAssertTrue(error is DecodingError)
        }
    }
}

// MARK: - Test Models

private struct TestRequest: Codable {
    let name: String
    let value: Int
}

private struct HTTPBinResponse: Codable {
    let url: String
    let method: String?
    let json: TestRequest?
}

private struct InvalidResponse: Codable {
    let nonExistentField: String
}

