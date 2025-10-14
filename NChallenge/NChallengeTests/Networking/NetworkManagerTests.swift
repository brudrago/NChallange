import XCTest
@testable import NChallenge

final class NetworkManagerTests: XCTestCase {
    
    private lazy var sut = NetworkManager()
    
    
    func testRequest_WithValidURL_ShouldReturnData() async throws {
        let url = "https://httpbin.org/get"
        let method = HTTPMethod.GET
        let responseType = HTTPBinResponse.self

        let response = try await sut.request(
            url: url,
            method: method,
            body: nil,
            responseType: responseType
        )
        
        XCTAssertNotNil(response)
        XCTAssertEqual(response.url, url)
    }
    
    func testRequest_WithPOST_ShouldReturnData() async throws {
        let url = "https://httpbin.org/post"
        let method = HTTPMethod.POST
        let body = TestRequest(name: "Test", value: 123)
        let responseType = HTTPBinResponse.self
        
        let response = try await sut.request(
            url: url,
            method: method,
            body: body,
            responseType: responseType
        )
        

        XCTAssertNotNil(response)
        XCTAssertEqual(response.url, url)
    }
    
    func testRequest_WithNonExistentURL_ShouldThrowError() async {
        let url = "https://non-existent-domain-12345.com"
        let method = HTTPMethod.GET
        let responseType = HTTPBinResponse.self
        
        do {
            _ = try await sut.request(
                url: url,
                method: method,
                body: nil,
                responseType: responseType
            )
            XCTFail("Should throw network error")
        } catch {
            XCTAssertTrue(error is URLError)
        }
    }
    
    func testRequest_WithInvalidResponseType_ShouldThrowDecodingError() async {
        let url = "https://httpbin.org/get"
        let method = HTTPMethod.GET
        let responseType = InvalidResponse.self
        
        do {
            _ = try await sut.request(
                url: url,
                method: method,
                body: nil,
                responseType: responseType
            )
            XCTFail("Should throw decoding error")
        } catch {
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

