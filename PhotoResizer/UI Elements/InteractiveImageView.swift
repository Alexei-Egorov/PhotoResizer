import UIKit

protocol ImageRotationDelegate: UIViewController {
    var imageRotation: CGFloat { get set }
}

class InteractiveImageView: UIImageView {

    weak var delegate: ImageRotationDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let panGesture = UIPanGestureRecognizer(target: delegate, action: #selector(handlePan(_:)))
        self.addGestureRecognizer(panGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: delegate, action: #selector(handlePinch(_:)))
        self.addGestureRecognizer(pinchGesture)
        
        let rotationGesture = UIRotationGestureRecognizer(target: delegate, action: #selector(handleRotation(_:)))
        self.addGestureRecognizer(rotationGesture)
    }
    
    @objc private func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let view = gestureRecognizer.view else { return }
        let translation = gestureRecognizer.translation(in: delegate?.view)
        view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        gestureRecognizer.setTranslation(.zero, in: delegate?.view)
    }
    
    @objc func handlePinch(_ gestureRecognizer: UIPinchGestureRecognizer) {
        guard let view = gestureRecognizer.view else { return }
        view.transform = view.transform.scaledBy(x: gestureRecognizer.scale, y: gestureRecognizer.scale)
        gestureRecognizer.scale = 1.0
    }
    
    @objc func handleRotation(_ gestureRecognizer: UIRotationGestureRecognizer) {
        guard let view = gestureRecognizer.view else { return }
        
        view.transform = view.transform.rotated(by: gestureRecognizer.rotation)
        delegate?.imageRotation += gestureRecognizer.rotation
        
        gestureRecognizer.rotation = 0.0
    }

}
