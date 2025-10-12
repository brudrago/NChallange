import Foundation

protocol HomePresentationLogic {
    func presentShortenedURL(response: HomeModels.ShortenUrl.Response)
    func presentAllShortenedURLs(response: HomeModels.DisplayList.Response)
}

final class HomePresenter: HomePresentationLogic {

    weak var viewController: HomeViewDisplayLogic?
    
    init() {}
    
    func presentShortenedURL(response: HomeModels.ShortenUrl.Response) {
        // Quando uma nova URL é encurtada, busca todas as URLs para atualizar a lista
        // Isso será tratado pelo interactor chamando presentAllShortenedURLs
        viewController?.displayList(viewModel: .init(shortenURL: response.shortenURL))
    }
    
    func presentAllShortenedURLs(response: HomeModels.DisplayList.Response) {
        viewController?.displayList(viewModel: .init(shortenedURLs: response.shortenedURLs))
    }
}
