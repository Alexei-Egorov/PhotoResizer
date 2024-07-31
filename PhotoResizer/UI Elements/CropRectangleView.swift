import UIKit

class CropRectangleView: UIView {
    
    // MARK: - Properties
    
    private(set) var cropFrame: CGRect?
    private var borderView: UIView = UIView()
    
    // MARK: - Initialization
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    // MARK: - Methods
    
    func setupView() {
        
        self.isUserInteractionEnabled = false
        self.backgroundColor = .white.withAlphaComponent(0.3)
        
        let subtractView = UIView(frame: CGRect(x: frame.origin.x + 50.0, y: frame.origin.y + 100.0, width: frame.width - 100.0, height: frame.height - 200.0))
        subtractView.backgroundColor = .clear
        self.addSubview(subtractView)
        cropFrame = subtractView.frame
        
        let maskLayer = CAShapeLayer()
        let basePath = UIBezierPath(rect: self.bounds)
        let subtractPath = UIBezierPath(
            rect: subtractView.frame.offsetBy(
                dx: -self.frame.origin.x, 
                dy: -self.frame.origin.y
            )
        )
        
        basePath.append(subtractPath)
        maskLayer.path = basePath.cgPath
        maskLayer.fillRule = .evenOdd
        
        self.layer.mask = maskLayer
    }
    
    func setupBorderView() {
        guard let cropFrame else {
            print("Didn't find cropFrame")
            return
        }
        borderView = UIView(frame: cropFrame)
        borderView.isUserInteractionEnabled = false
        borderView.backgroundColor = .clear
        borderView.layer.borderColor = UIColor.yellow.cgColor
        borderView.layer.borderWidth = 2.0
        self.superview?.addSubview(borderView)
    }
    
    func removeBorderView() {
        borderView.removeFromSuperview()
    }
}
