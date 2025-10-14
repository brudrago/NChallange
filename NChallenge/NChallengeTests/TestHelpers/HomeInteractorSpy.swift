@testable import NChallenge

final class HomeInteractorSpy: HomeBusinessLogic {
    private(set) var lastURL: String?
    private(set) var getShortenedURLCalled = false
    
    func getShortenedURL(request: HomeModels.ShortenUrl.Request) {
        getShortenedURLCalled = true
        lastURL = request.url
    }
    
    private(set) var getAllShortenedURLsCalled = false
    
    func getAllShortenedURLs(request: HomeModels.DisplayList.Request) {
        getAllShortenedURLsCalled = true
    }
}
