@testable import NChallenge

final class HomeViewControllerSpy: HomeViewDisplayLogic {
    private(set) var displayListCalled = false
    private(set) var lastShortenedURLs: [ShortenedURL]?
    
    func displayList(viewModel: HomeModels.DisplayList.ViewModel) {
        displayListCalled = true
        lastShortenedURLs = viewModel.shortenedURLs
    }
    
    private(set) var lastErrorMessage: String?
    private(set) var displayErrorCalled = false
    
    func displayError(viewModel: HomeModels.Error.ViewModel) {
        displayErrorCalled = true
        lastErrorMessage = viewModel.message
    }
}
