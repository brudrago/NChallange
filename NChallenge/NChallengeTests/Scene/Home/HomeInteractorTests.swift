import XCTest
@testable import NChallenge

final class HomeInteractorTests: XCTestCase {
    
    private let presenterSpy = HomePresenterSpy()
    private let repositorySpy = ShortenedURLRepositorySpy()
    private let useCaseSpy = ShortenedURLUseCaseSpy()
    
    private lazy var sut = HomeInteractor(
        presenter: presenterSpy,
        router: HomeRouterSpy(),
        urlShortenUseCase: useCaseSpy,
        repository: repositorySpy
    )

    func testGetShortenedURL_WithURLAlreadyCached_ShouldPresentError() async {
        let url = "https://example.com"
        repositorySpy.isURLAlreadyCachedResult = true
        
        sut.getShortenedURL(request: .init(url: url))
        
        await waitForAsyncOperation()
        
        XCTAssertTrue(repositorySpy.isURLAlreadyCachedCalled)
        XCTAssertEqual(repositorySpy.lastCheckedURL, url)
        XCTAssertTrue(presenterSpy.presentErrorCalled)
        XCTAssertEqual(presenterSpy.lastErrorMessage, AppStrings.Alerts.urlAlreadyShortened)
    }
    
    func testGetShortenedURL_WithNewURL_ShouldSaveAndPresentURL() async {
        let url = "https://example.com"
        let shortenedURL = ShortenedURL.fixture(originalURL: url)
        
        repositorySpy.isURLAlreadyCachedResult = false
        useCaseSpy.responseToBeReturned = shortenedURL
        repositorySpy.getAllResult = [shortenedURL]
        
        sut.getShortenedURL(request: .init(url: url))
        
        await waitForAsyncOperation()
        
        XCTAssertTrue(repositorySpy.isURLAlreadyCachedCalled)
        XCTAssertEqual(useCaseSpy.lastURLString, url)
        XCTAssertTrue(repositorySpy.saveCalled)
        XCTAssertEqual(repositorySpy.savedURL, shortenedURL)
        XCTAssertTrue(presenterSpy.presentAllShortenedURLsCalled)
        XCTAssertEqual(presenterSpy.lastShortenedURLs?.count, 1)
    }
    
    func testGetShortenedURL_WithUseCaseError_ShouldPresentError() async {
        let url = "https://example.com"
        let error = NetworkError.invalidResponse(statusCode: 500)
        
        repositorySpy.isURLAlreadyCachedResult = false
        useCaseSpy.errorToBeReturned = error
        
        sut.getShortenedURL(request: .init(url: url))
        
        await waitForAsyncOperation()
        
        XCTAssertTrue(presenterSpy.presentErrorCalled)
        XCTAssertEqual(presenterSpy.lastErrorMessage, AppStrings.Alerts.shortenFailed)
    }

    func testGetAllShortenedURLs_ShouldPresentAllURLs() async {
        let urls = [
            ShortenedURL.fixture(alias: "abc123"),
            ShortenedURL.fixture(alias: "def456")
        ]
        repositorySpy.getAllResult = urls
        
        sut.getAllShortenedURLs(request: .init())
        
        await waitForAsyncOperation()
        
        XCTAssertTrue(repositorySpy.getAllCalled)
        XCTAssertTrue(presenterSpy.presentAllShortenedURLsCalled)
        XCTAssertEqual(presenterSpy.lastShortenedURLs?.count, 2)
    }
}

extension XCTestCase {
    func waitForAsyncOperation(timeout: TimeInterval = 0.1) async {
        try? await Task.sleep(nanoseconds: UInt64(timeout * 1_000_000_000))
    }
}

