@testable import NChallenge

final class HomeViewDelegateSpy: HomeViewDelegate {
    private(set) var lastText: String?
    private(set) var didTapSendButtonCallCount = 0
    
    func didTapSendButton(_ text: String) {
        lastText = text
        didTapSendButtonCallCount += 1
    }
}
