import XCTest
@testable import NChallenge

final class HomeViewControllerTests: XCTestCase {
    private let interactorSpy = HomeInteractorSpy()
    private let homeViewSpy = HomeViewSpy()
    
    private lazy var sut = HomeViewController(
        customView: homeViewSpy,
        interactor: interactorSpy
    )

    func test_viewDidLoad_shouldLoadAllShortenedURLs() {
        sut.viewDidLoad()
        
        XCTAssertTrue(interactorSpy.getAllShortenedURLsCalled)
    }

    func test_displayList_shouldUpdateView() {
        let urls = [
            ShortenedURL.fixture(alias: "abc123"),
            ShortenedURL.fixture(alias: "def456")
        ]
        
        sut.displayList(viewModel: .init(shortenedURLs: urls))

        XCTAssertTrue(homeViewSpy.updateShortenedURLsCalled)
    }

    func test_didTapSendButton_withValidURL_shouldCallInteractor() {
        let url = "https://example.com"
        
        sut.didTapSendButton(url)
        
        XCTAssertTrue(interactorSpy.getShortenedURLCalled)
        XCTAssertEqual(interactorSpy.lastURL, url)
    }
}
