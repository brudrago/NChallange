import UIKit


struct UrlListConfigurator {
    static func configure() -> UIViewController {
        let view = UrlListView()
        let repository = ShortenedURLRepository()
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
