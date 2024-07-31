import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel: SettingsViewModel!
    
    // MARK: - Initialization
    
    convenience init(viewModel: SettingsViewModel!) {
        self.init()
        self.viewModel = viewModel
        print("SettingsViewController initiated")
    }
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    deinit {
        print("SettingsViewController has been deinitialized")
    }

}
