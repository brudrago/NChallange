import UIKit


struct HomeConfigurator {
    static func configure() -> UIViewController {
        let view = HomeView()
        let router = HomeRouter()
        let presenter = HomePresenter()
        
        let networkManager = NetworkManager()
        let service = ShortenedURLService(networkManager: networkManager)
        let mapper = ShortenedURLMapper()
        let useCase = ShortenedURLUseCase(service: service, mapper: mapper)
        
        let interactor = HomeInteractor(
            presenter: presenter,
            router: router,
            urlShortenUseCase: useCase
        )
        
        let viewController = HomeViewController(
            customView: view,
            interactor: interactor
        )
        
        view.delegate = viewController
        presenter.viewController = viewController
        router.viewController = viewController
        
        return viewController
    }
}
