import UIKit


struct UrlListConfigurator {
    static func configure(dependencies: DependencyContainer = .shared) -> UIViewController {
        let view = UrlListView()
        let repository = dependencies.repository
        let presenter = UrlListPresenter()
        
        let interactor = UrlListInteractor(
            repository: repository,
            presenter: presenter
        )
 
        let viewController = UrlListViewController(
            customView: view,
            interactor: interactor
        )
        
        presenter.viewController = viewController
        
        return viewController
    }
}
