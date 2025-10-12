import UIKit

protocol HomeViewDisplayLogic: AnyObject {
    func displayList(viewModel: HomeModels.ShortenUrl.ViewModel)
    func displayList(viewModel: HomeModels.DisplayList.ViewModel)
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
    func displayList(viewModel: HomeModels.ShortenUrl.ViewModel) {
        // Para uma URL individual, converte para array
        let urls = [viewModel.shortenURL]
        customView.updateShortenedURLs(urls)
    }
    
    func displayList(viewModel: HomeModels.DisplayList.ViewModel) {
        let urls = viewModel.shortenedURLs
        customView.updateShortenedURLs(urls)
    }
}

extension HomeViewController: HomeViewDelegate {
    func didTapSendButton(_ text: String) {
        interactor.getShortenedURL(request: .init(url: text))
    }
}

