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
        if let cachedURL = repository.getCachedURL(for: request.url) {
            print("✅ URL found in cache: \(cachedURL.alias)")
            // Busca todas as URLs para atualizar a lista completa
            let allURLs = repository.getAll()
            presenter.presentAllShortenedURLs(response: .init(shortenedURLs: allURLs))
            return
        }
        
        Task {
            do {
                let response = try await urlShortenUseCase.shorten(urlString: request.url)
                repository.save(response)
                
                // Após salvar, busca todas as URLs para atualizar a lista completa
                let allURLs = repository.getAll()
                presenter.presentAllShortenedURLs(response: .init(shortenedURLs: allURLs))
            } catch {
                print("❌ Interactor error: \(error)")
                // Aqui você pode chamar o presenter para mostrar erro
                // presenter.presentError(error)
            }
        }
    }
    
    func getAllShortenedURLs(request: HomeModels.DisplayList.Request) {
        let allURLs = repository.getAll()
        presenter.presentAllShortenedURLs(response: .init(shortenedURLs: allURLs))
    }
    
}
