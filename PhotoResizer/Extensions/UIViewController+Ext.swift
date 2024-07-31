import UIKit

extension UIViewController {
    
    func setupSaveBarButtonItem() {
        let button = UIButton(type: .system)
        let image = UIImage(named: "floppy-disk")?.resizeImage(targetSize: CGSize(width: 30.0, height: 30.0))
        
        var config = UIButton.Configuration.plain()
        config.title = "Save"
        config.image = image
        config.imagePadding = 8
        config.imagePlacement = .leading
        
        button.configuration = config
        button.tintColor = .black
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 100),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        let barButtonItem = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    func setupResetBarButtonItem() {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "arrow.uturn.backward.circle")?.resizeImage(targetSize: CGSize(width: 30.0, height: 30.0))
        
        var config = UIButton.Configuration.plain()
        config.title = "Reset"
        config.image = image
        config.imagePadding = 8
        config.imagePlacement = .leading
        
        button.configuration = config
        button.tintColor = .black
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 110),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        let barButtonItem = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = barButtonItem
    }
}
