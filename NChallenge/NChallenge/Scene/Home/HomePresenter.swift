import Foundation

protocol HomePresentationLogic {
    func presentAllShortenedURLs(response: HomeModels.DisplayList.Response)
    func presentError(response: HomeModels.Error.Response)
}

final class HomePresenter: HomePresentationLogic {

    weak var viewController: HomeViewDisplayLogic?
    
    init() {}
    
    func presentAllShortenedURLs(response: HomeModels.DisplayList.Response) {
        viewController?.displayList(viewModel: .init(shortenedURLs: response.shortenedURLs))
    }
    
    func presentError(response: HomeModels.Error.Response) {
        viewController?.displayError(viewModel: .init(message: response.message))
    }
}
