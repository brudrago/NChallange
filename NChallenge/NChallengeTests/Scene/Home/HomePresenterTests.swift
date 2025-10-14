import XCTest
@testable import NChallenge

final class HomePresenterTests: XCTestCase {
    private let viewControllerSpy = HomeViewControllerSpy()

    private lazy var sut: HomePresentationLogic = {
        let presenter = HomePresenter()
        presenter.viewController = viewControllerSpy
        return presenter
    }()
    
    func test_presentAllShortenedURLs_shouldDisplayList() {
        let urls = [
            ShortenedURL.fixture(alias: "abc123"),
            ShortenedURL.fixture(alias: "def456")
        ]
        let response = HomeModels.DisplayList.Response(shortenedURLs: urls)
        
        sut.presentAllShortenedURLs(response: response)
        
        XCTAssertTrue(viewControllerSpy.displayListCalled)
        XCTAssertEqual(viewControllerSpy.lastShortenedURLs?.count, 2)
    }
    
    func test_presentError_shouldDisplayError() {
        let message = "Test error message"
        let response = HomeModels.Error.Response(message: message)
        
        sut.presentError(response: response)
        
        XCTAssertTrue(viewControllerSpy.displayErrorCalled)
        XCTAssertEqual(viewControllerSpy.lastErrorMessage, message)
    }
}
