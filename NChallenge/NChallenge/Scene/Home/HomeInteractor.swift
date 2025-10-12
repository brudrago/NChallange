import Foundation

protocol HomeBusinessLogic {}

final class HomeInteractor: HomeBusinessLogic {
    private let presenter: HomePresentationLogic
    private let router: HomeRoutingLogic
    
    init(
        presenter: any HomePresentationLogic,
        router: HomeRoutingLogic
    ) {
        self.presenter = presenter
        self.router = router
    }
    
}
