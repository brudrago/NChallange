import Foundation

protocol HomeBusinessLogic {
    func getShortenedURL(request: HomeModels.ShortenUrl.Request)
    func getAllShortenedURLs(request: HomeModels.DisplayList.Request)
    func showUrlsList(request: HomeModels.ShowUrlsList.Request)
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
                
                // Busca apenas a última URL (a mais recente)
                let allURLs = await repository.getAll()
                let lastURL = allURLs.last
                let lastURLs = lastURL.map { [$0] } ?? []
                presenter.presentAllShortenedURLs(response: .init(shortenedURLs: lastURLs))
            } catch {
                presenter.presentError(response: .init(message: AppStrings.Alerts.shortenFailed))
            }
        }
    }
    
    func getAllShortenedURLs(request: HomeModels.DisplayList.Request) {
        Task {
            // Busca apenas a última URL (a mais recente)
            let allURLs = await repository.getAll()
            let lastURL = allURLs.last
            let lastURLs = lastURL.map { [$0] } ?? []
            presenter.presentAllShortenedURLs(response: .init(shortenedURLs: lastURLs))
        }
    }
    
    func showUrlsList(request: HomeModels.ShowUrlsList.Request) {
        router.navigateToListView()
    }
    
}
