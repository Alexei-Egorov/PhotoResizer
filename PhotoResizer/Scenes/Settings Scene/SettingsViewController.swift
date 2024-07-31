import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Properties
    
    private var viewModel: SettingsViewModel!
    
    // MARK: - Initialization
    
    convenience init(viewModel: SettingsViewModel!) {
        self.init()
        self.viewModel = viewModel
    }
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    // MARK: - Methods
    
    private func showAlert() {
        let alertController = UIAlertController(title: viewModel.authorName, message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}

// MARK: - UITableView Delegate

extension SettingsViewController: UITableViewDelegate { }

// MARK: - UITableView Data Source

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            fatalError()
        }
        cell.textLabel?.text = viewModel.cellTitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showAlert()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
