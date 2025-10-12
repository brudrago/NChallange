import UIKit

class HomeViewController: UIViewController {
    private var customView: HomeViewDisplayLogic
    
    init(customView: any HomeViewDisplayLogic) {
        self.customView = customView
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
        title = "Home"
        // Do any additional setup after loading the view.
    }


}

