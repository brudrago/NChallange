import UIKit


struct HomeConfigurator {
    static func configure() -> UIViewController {
        let view = HomeView()
        let router = HomeRouter()
        let presenter = HomePresenter()
        
        let interactor = HomeInteractor(
            presenter: presenter,
            router: router
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
