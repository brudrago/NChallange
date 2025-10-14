@testable import NChallenge

final class ShortenedURLUseCaseSpy: ShortenedURLUseCaseProtocol {
    private(set) var lastURLString: String?
    
    var responseToBeReturned: ShortenedURL?
    var errorToBeReturned: Error?
    
    func shorten(urlString: String) async throws -> ShortenedURL {
        lastURLString = urlString
        
        if let error = errorToBeReturned {
            throw error
        }
        
        return responseToBeReturned ?? ShortenedURL.fixture()
    }
}
