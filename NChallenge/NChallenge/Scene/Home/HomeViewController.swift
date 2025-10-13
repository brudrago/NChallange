import UIKit

protocol HomeViewDisplayLogic: AnyObject {
    func displayList(viewModel: HomeModels.DisplayList.ViewModel)
    func displayError(viewModel: HomeModels.Error.ViewModel)
}

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
        loadAllShortenedURLs()
    }
    
    private func loadAllShortenedURLs() {
        interactor.getAllShortenedURLs(request: .init())
    }
}

extension HomeViewController: HomeViewDisplayLogic {
    func displayList(viewModel: HomeModels.DisplayList.ViewModel) {
        let urls = viewModel.shortenedURLs
        customView.updateShortenedURLs(urls)
    }
    
    func displayError(viewModel: HomeModels.Error.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.showAlert(title: AppStrings.Alerts.errorTitle, message: viewModel.message)
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AppStrings.Alerts.okButton, style: .default))
        present(alert, animated: true)
    }
}

extension HomeViewController: HomeViewDelegate {
    func didTapSendButton(_ text: String) {
        interactor.getShortenedURL(request: .init(url: text))
    }
}

