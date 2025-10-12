import UIKit

protocol HomeViewDisplayLogic: AnyObject {}

final class HomeViewController: UIViewController {
    private var customView: HomeViewProtocol
    private let interactor: HomeBusinessLogic
    
    init(
        customView: HomeViewProtocol,
        interactor: HomeBusinessLogic
    ) {
        self.customView = customView
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension HomeViewController: HomeViewDisplayLogic {}

extension HomeViewController: HomeViewDelegate {
    func didTapSendButton(_ text: String) {
        print("Text: \(text)")
    }
}

