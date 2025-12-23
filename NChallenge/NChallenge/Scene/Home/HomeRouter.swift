import UIKit

protocol HomeRoutingLogic {
    func navigateToListView()
}

final class HomeRouter: HomeRoutingLogic {
    weak var viewController: UIViewController?
    
    init() {}
    
    func navigateToListView() {
        let controller = UrlListConfigurator.configure() 
        viewController?.navigationController?.pushViewController(controller, animated: true)
    }
}
