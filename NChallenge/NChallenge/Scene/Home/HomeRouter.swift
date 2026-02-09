import UIKit

protocol HomeRoutingLogic {
    func navigateToListView()
}

final class HomeRouter: HomeRoutingLogic {
    weak var viewController: UIViewController?
    
    private let dependencies: DependencyContainer
    
    init(dependencies: DependencyContainer = .shared) {
        self.dependencies = dependencies
    }
    
    func navigateToListView() {
        let controller = UrlListConfigurator.configure(dependencies: dependencies)
        viewController?.navigationController?.pushViewController(controller, animated: true)
    }
}
