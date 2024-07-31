import UIKit

protocol InteractiveImageViewDelegate: UIViewController {
    var imageRotation: CGFloat { get set }
}

class InteractiveImageView: UIImageView {
    
    // MARK: - Properties

    weak var delegate: InteractiveImageViewDelegate?
    
    // MARK: - Initialization
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = true
        setupGestures()
    }
    
    // MARK: - Methods
    
    private func setupGestures() {
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.addGestureRecognizer(panGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        self.addGestureRecognizer(pinchGesture)
        
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(_:)))
        self.addGestureRecognizer(rotationGesture)
    }
    
    @objc private func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let view = gestureRecognizer.view else { return }
        let translation = gestureRecognizer.translation(in: delegate?.view)
        view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        gestureRecognizer.setTranslation(.zero, in: delegate?.view)
    }
    
    @objc private func handlePinch(_ gestureRecognizer: UIPinchGestureRecognizer) {
        guard let view = gestureRecognizer.view else { return }
        view.transform = view.transform.scaledBy(x: gestureRecognizer.scale, y: gestureRecognizer.scale)
        gestureRecognizer.scale = 1.0
    }
    
    @objc private func handleRotation(_ gestureRecognizer: UIRotationGestureRecognizer) {
        guard let view = gestureRecognizer.view else { return }
        view.transform = view.transform.rotated(by: gestureRecognizer.rotation)
        delegate?.imageRotation += gestureRecognizer.rotation
        gestureRecognizer.rotation = 0.0
    }

}
