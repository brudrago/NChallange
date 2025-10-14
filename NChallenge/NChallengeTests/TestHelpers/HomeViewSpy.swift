import UIKit
@testable import NChallenge

final class HomeViewSpy: UIView, HomeViewProtocol {
    private(set) var updateShortenedURLsCalled = false
    private(set) var URLsPassed: [ShortenedURL]?

    func updateShortenedURLs(_ urls: [ShortenedURL]) {
        updateShortenedURLsCalled = true
        URLsPassed = urls
    }
}
