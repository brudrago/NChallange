
import Foundation

protocol UrlListInteractorProtocol {
    func getAllShortenedURLs(request: UrlListModels.DisplayList.Request)
}

final class UrlListInteractor: UrlListInteractorProtocol {
    private let repository: ShortenedURLRepositoryProtocol
    private let presenter: UrlListPresenterProtocol
    
    init(
        repository: ShortenedURLRepositoryProtocol,
        presenter: UrlListPresenterProtocol
    ) {
        self.repository = repository
        self.presenter = presenter
    }
    
    func getAllShortenedURLs(request: UrlListModels.DisplayList.Request) {
        Task {
            let allURLs = await repository.getAll()
            presenter.presentAllShortenedURLs(response: .init(shortenedURLs: allURLs))
        }
    }
}
