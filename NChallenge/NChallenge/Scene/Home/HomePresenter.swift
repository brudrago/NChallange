import Foundation

protocol HomePresentationLogic {}

final class HomePresenter: HomePresentationLogic {
    weak var viewController: HomeViewDisplayLogic?
}
