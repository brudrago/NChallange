import Foundation

protocol HomeBusinessLogic {
    func getShortenedURL(request: HomeModels.ShortenUrl.Request)
    func getAllShortenedURLs(request: HomeModels.DisplayList.Request)
}

final class HomeInteractor: HomeBusinessLogic {
    private let presenter: HomePresentationLogic
    private let router: HomeRoutingLogic
    private let urlShortenUseCase: ShortenedURLUseCaseProtocol
    private let repository: ShortenedURLRepositoryProtocol
    
    init(
        presenter: any HomePresentationLogic,
        router: HomeRoutingLogic,
        urlShortenUseCase: ShortenedURLUseCaseProtocol,
        repository: ShortenedURLRepositoryProtocol
    ) {
        self.presenter = presenter
        self.router = router
        self.urlShortenUseCase = urlShortenUseCase
        self.repository = repository
    }
    
    func getShortenedURL(request: HomeModels.ShortenUrl.Request) {
        Task {
            if await repository.isURLAlreadyCached(request.url) {
                presenter.presentError(response: .init(message: AppStrings.Alerts.urlAlreadyShortened))
                return
            }
            
            do {
                let response = try await urlShortenUseCase.shorten(urlString: request.url)
                await repository.save(response)
                
                let allURLs = await repository.getAll()
                presenter.presentAllShortenedURLs(response: .init(shortenedURLs: allURLs))
            } catch {
                presenter.presentError(response: .init(message: AppStrings.Alerts.shortenFailed))
            }
        }
    }
    
    func getAllShortenedURLs(request: HomeModels.DisplayList.Request) {
        Task {
            let allURLs = await repository.getAll()
            presenter.presentAllShortenedURLs(response: .init(shortenedURLs: allURLs))
        }
    }
    
}
