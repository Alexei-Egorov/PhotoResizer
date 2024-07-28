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
        
        setupImage()
    }
    
    private func setupImage() {
        guard let image = UIImage(named: "bird") else {
            print("Image not found")
            return
        }
        
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: image.size))
        imageView.image = image
        imageView.isUserInteractionEnabled = true
        view.addSubview(imageView)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        imageView.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let view = gestureRecognizer.view else { return }
        
        let translation = gestureRecognizer.translation(in: self.view)
        
        view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        
        gestureRecognizer.setTranslation(.zero, in: self.view)
    }
    
    deinit {
        print("SettingsViewController has been deinitialized")
    }

}
