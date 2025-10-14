import Foundation
@testable import NChallenge

final class ShortenedURLServiceSpy: ShortenedURLServiceProtocol {
    private(set) var lastURLString: String?
    private(set) var shortenCallCount = 0
    
    var responseToBeReturned: URLShortenedResponseDTO?
    var errorToBeReturned: Error?
    
    func shorten(urlString: String) async throws -> URLShortenedResponseDTO {
        shortenCallCount += 1
        lastURLString = urlString
        
        if let error = errorToBeReturned {
            throw error
        }
        
        if let response = responseToBeReturned {
            return response
        }
        
        return URLShortenedResponseDTO.fixture()
    }
}
