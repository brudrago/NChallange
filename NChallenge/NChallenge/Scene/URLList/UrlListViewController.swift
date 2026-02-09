import UIKit

protocol UrlListViewDisplayLogic: AnyObject {
    func displayList(viewModel: UrlListModels.DisplayList.ViewModel)
}

final class UrlListViewController: UIViewController, UrlListViewDisplayLogic {
    private var customView: UrlListViewProtocol
    private let interactor: UrlListInteractorProtocol
    
    init(
        customView: UrlListViewProtocol,
        interactor: UrlListInteractorProtocol
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
        interactor.getAllShortenedURLs(request: .init())
    }
    
    func displayList(viewModel: UrlListModels.DisplayList.ViewModel) {
        let urls = viewModel.shortenedURLs
        customView.updateShortenedURLs(urls)
    }
   
}
