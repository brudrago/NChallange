import XCTest
@testable import NChallenge

final class NetworkManagerTests: XCTestCase {
    
    private lazy var sut = NetworkManager()
    
    func test_request_withValidURL_shouldReturnData() async throws {
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
    
    func test_request_withPOST_shouldReturnData() async throws {
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
    
    func test_request_withNonExistentURL_shouldThrowError() async {
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
    
    func test_request_withInvalidResponseType_shouldThrowDecodingError() async {
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

private extension NetworkManagerTests {
    struct TestRequest: Codable {
        let name: String
        let value: Int
    }
    
    struct HTTPBinResponse: Codable {
        let url: String
        let method: String?
        let json: TestRequest?
    }
    
    struct InvalidResponse: Codable {
        let nonExistentField: String
    }
}



