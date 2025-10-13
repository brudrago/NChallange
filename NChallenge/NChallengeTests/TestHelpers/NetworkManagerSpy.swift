import Foundation
@testable import NChallenge

final class NetworkManagerSpy: NetworkManagerProtocol {
    private(set) var lastURL: String?
    private(set) var lastMethod: HTTPMethod?
    private(set) var lastBody: Encodable?
    private(set) var requestCallCount = 0
    
    var responseToBeReturned: Any?
    var errorToBeReturned: Error?
    
    func request<T: Decodable>(
        url: String,
        method: HTTPMethod,
        body: Encodable?,
        responseType: T.Type
    ) async throws -> T {
        requestCallCount += 1
        lastURL = url
        lastMethod = method
        lastBody = body
        
        if let error = errorToBeReturned {
            throw error
        }
        
        if let response = responseToBeReturned as? T {
            return response
        }
        
        throw NetworkError.invalidResponse(statusCode: 500)
    }
}
