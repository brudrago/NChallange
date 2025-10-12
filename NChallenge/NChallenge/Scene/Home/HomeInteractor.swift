import Foundation

protocol HomeBusinessLogic {
    func getShortenedURL(for url: String)
}

final class HomeInteractor: HomeBusinessLogic {
    private let presenter: HomePresentationLogic
    private let router: HomeRoutingLogic
    private let urlShortenUseCase: ShortenedURLUseCaseProtocol
    
    init(
        presenter: any HomePresentationLogic,
        router: HomeRoutingLogic,
        urlShortenUseCase: ShortenedURLUseCaseProtocol
    ) {
        self.presenter = presenter
        self.router = router
        self.urlShortenUseCase = urlShortenUseCase
    }
    
    func getShortenedURL(for url: String) {
        Task {
            do {
                let response = try await urlShortenUseCase.shorten(urlString: url)
                print("✅ Interactor received response: \(response.alias)")
                // Aqui você pode chamar o presenter para atualizar a view
                // presenter.presentShortenedURL(response)
            } catch {
                print("❌ Interactor error: \(error)")
                // Aqui você pode chamar o presenter para mostrar erro
                // presenter.presentError(error)
            }
        }
    }
    
}
