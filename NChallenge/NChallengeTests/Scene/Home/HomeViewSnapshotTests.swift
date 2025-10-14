import XCTest
import SnapshotTesting
@testable import NChallenge

final class HomeViewSnapshotTests: XCTestCase {

    override func setUp() {
        super.setUp()
        UIView.setAnimationsEnabled(false)
    }

    override func tearDown() {
        UIView.setAnimationsEnabled(true)
        super.tearDown()
    }

    // MARK: - Cenários

    func test_homeView_initial_light() {
        let (homeView, vc) = makeSUT()
        homeView.updateShortenedURLs([])

        assertSnapshot(
            of: vc,
            as: .image(on: .iPhone13Pro)
        )
    }

    func test_homeView_withValidText_buttonEnabled() {
        let (homeView, vc) = makeSUT()
        homeView.updateShortenedURLs([])

        if let textField: UITextField = find(in: homeView, id: "home.textField") {
            textField.text = "https://example.com"
            textField.sendActions(for: .editingChanged)
        }

        vc.view.layoutIfNeeded()

        assertSnapshot(
            of: vc,
            as: .image(on: .iPhone13Pro)
        )
    }

    func test_homeView_withListItems() {
        let (homeView, vc) = makeSUT()
        
        let urlOne = ShortenedURL.fixture(
            alias: "abc123",
            originalURL: "https://example.com",
            shortURL: "https://short.ly/abc123"
        )
        
        let urlTwo = ShortenedURL.fixture(
            alias: "def456",
            originalURL: "https://test.com",
            shortURL: "https://short.ly/def456"
        )
        
        let urlThree = ShortenedURL.fixture(
            alias: "ghi789",
            originalURL: "https://snapshot.com",
            shortURL: "https://short.ly/ghi789"
        )

        let items: [ShortenedURL] = [urlOne, urlTwo, urlThree]
        homeView.updateShortenedURLs(items)
        vc.view.layoutIfNeeded()

        assertSnapshot(
            of: vc,
            as: .image(on: .iPhone13Pro)
        )
    }
}

private extension HomeViewSnapshotTests {

    func makeSUT() -> (HomeView, UIViewController) {
        let home = HomeView(frame: .zero)
        let controller = UIViewController()
        controller.view = home
        controller.view.backgroundColor = .systemBackground

        controller.view.frame = CGRect(x: 0, y: 0, width: 390, height: 844)
        controller.view.setNeedsLayout()
        controller.view.layoutIfNeeded()

        return (home, controller)
    }

    func find<T: UIView>(in root: UIView, id: String) -> T? {
        if root.accessibilityIdentifier == id, let typed = root as? T { return typed }
        for sub in root.subviews {
            if let m: T = find(in: sub, id: id) { return m }
        }
        return nil
    }
}

