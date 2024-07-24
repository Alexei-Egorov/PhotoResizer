import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel: MainViewModel!
    
    // MARK: - Initialization
    
    convenience init(viewModel: MainViewModel!) {
        self.init()
        self.viewModel = viewModel
        print("MainViewController initiated")
    }
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    deinit {
        print("MainViewController has been deinitialized")
    }

}
