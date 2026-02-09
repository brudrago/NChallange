import UIKit


struct HomeConfigurator {
    static func configure(dependencies: DependencyContainer = .shared) -> UIViewController {
        let view = HomeView()
        let router = HomeRouter(dependencies: dependencies)
        let presenter = HomePresenter()
        
        let useCase = dependencies.makeShortenedURLUseCase()
        let repository = dependencies.repository
        
        let interactor = HomeInteractor(
            presenter: presenter,
            router: router,
            urlShortenUseCase: useCase,
            repository: repository
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
