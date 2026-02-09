import Foundation

protocol UrlListPresenterProtocol {
    func presentAllShortenedURLs(response: UrlListModels.DisplayList.Response)
}

final class UrlListPresenter: UrlListPresenterProtocol {
    weak var viewController: UrlListViewDisplayLogic?
    
    init() {}
    
    func presentAllShortenedURLs(response: UrlListModels.DisplayList.Response) {
        viewController?.displayList(viewModel: .init(shortenedURLs: response.shortenedURLs))
    }
}
