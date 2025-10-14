@testable import NChallenge

final class HomePresenterSpy: HomePresentationLogic {
    private(set) var presentShortenedURLCalled = false
    private(set) var lastShortenedURL: ShortenedURL?
    
    func presentShortenedURL(response: HomeModels.ShortenUrl.Response) {
        presentShortenedURLCalled = true
        lastShortenedURL = response.shortenURL
    }
    
    private(set) var presentAllShortenedURLsCalled = false
    private(set) var lastShortenedURLs: [ShortenedURL]?
    
    func presentAllShortenedURLs(response: HomeModels.DisplayList.Response) {
        presentAllShortenedURLsCalled = true
        lastShortenedURLs = response.shortenedURLs
    }
    
    
    private(set) var presentErrorCalled = false
    private(set) var lastErrorMessage: String?
    
    func presentError(response: HomeModels.Error.Response) {
        presentErrorCalled = true
        lastErrorMessage = response.message
    }
}

final class HomeRouterSpy: HomeRoutingLogic {}
