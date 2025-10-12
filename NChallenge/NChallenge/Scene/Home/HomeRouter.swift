import UIKit

protocol HomeRoutingLogic {}

final class HomeRouter: HomeRoutingLogic {
    weak var viewController: UIViewController?
    
    init() {}
}
