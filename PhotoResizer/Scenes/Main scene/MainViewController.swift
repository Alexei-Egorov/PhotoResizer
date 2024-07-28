import UIKit

class MainViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet var maskView: UIView!
    
    // MARK: - Properties
    
    private var viewModel: MainViewModel!
    
    private var imageView: UIImageView!
    
    private var imageRotation: CGFloat = 0.0
    
    // MARK: - Initialization
    
    convenience init(viewModel: MainViewModel!) {
        self.init()
        self.viewModel = viewModel
        print("MainViewController initiated")
    }
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupView()
    }
    
    
    
    // MARK: - Methods
    
    private func setupView() {
        maskView.backgroundColor = .white.withAlphaComponent(0.3)
        
        setupImage()
    }
    
    private func setupNavigationBar() {
        let saveButton = UIBarButtonItem(title: "Save", image: UIImage(named: "floppy-disk"), target: self, action: #selector(cropImageAndSave))
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    private func setupImage() {
        guard let image = UIImage(named: "bird") else {
            print("Image not found")
            return
        }
        
        imageView = UIImageView(frame: CGRect(origin: .zero, size: image.size))
        imageView.image = image
        imageView.isUserInteractionEnabled = true
        view.insertSubview(imageView, belowSubview: maskView)
        
        print("image size: \(image.size)")
        print("UI scale: \(image.scale)")
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        imageView.addGestureRecognizer(panGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        imageView.addGestureRecognizer(pinchGesture)
        
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotation(_:)))
        imageView.addGestureRecognizer(rotationGesture)
    }
    
    private func saveImageToPhotos(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveImage(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    // MARK: - @objc Methods
    
    @objc private func cropImageAndSave() {
        guard let image = imageView.image, let rotatedImage = image.rotated(by: imageRotation) else { return }
        let imageSize = rotatedImage.size
        let imageScale = rotatedImage.scale
        print("Cropping image")
        let maskOrigin = maskView.frame.origin
        let imageOrigin = imageView.frame.origin
        
        let scaleFactor = imageSize.width * imageScale / imageView.frame.width
        
        print("scaleFactor: \(scaleFactor)")
        
        let xCrop = (maskOrigin.x - imageOrigin.x) * scaleFactor
        let yCrop = (maskOrigin.y - imageOrigin.y) * scaleFactor
        let cropWidth = maskView.frame.width * scaleFactor
        let cropHeight = maskView.frame.height * scaleFactor
        
        let cropOrigin = CGPoint(
            x: xCrop.rounded(),
            y: yCrop.rounded()
        )
        let cropRect = CGRect(
            origin: cropOrigin,
            size: CGSize(
                width: cropWidth.rounded(),
                height: cropHeight.rounded()
            )
        )
        
        print("cropRect: \(cropRect)")
        
        guard let croppedImage = rotatedImage.cropped(to: cropRect) else {
            return
        }
        
        saveImageToPhotos(image: croppedImage)
    }
    
    @objc func saveImage(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            present(alertController, animated: true)
        } else {
            let alertController = UIAlertController(title: "Saved", message: "The image has been saved to your photos.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            present(alertController, animated: true)
        }
    }
    
    @objc private func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let view = gestureRecognizer.view else { return }
        
        let translation = gestureRecognizer.translation(in: self.view)
        
        view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        
        gestureRecognizer.setTranslation(.zero, in: self.view)
    }
    
    @objc func handlePinch(_ gestureRecognizer: UIPinchGestureRecognizer) {
        guard let view = gestureRecognizer.view else { return }
        
        view.transform = view.transform.scaledBy(x: gestureRecognizer.scale, y: gestureRecognizer.scale)
        
        gestureRecognizer.scale = 1.0
    }
    
    @objc func handleRotation(_ gestureRecognizer: UIRotationGestureRecognizer) {
        guard let view = gestureRecognizer.view else { return }
        
        view.transform = view.transform.rotated(by: gestureRecognizer.rotation)
        imageRotation += gestureRecognizer.rotation
        
        gestureRecognizer.rotation = 0.0
    }
    

    deinit {
        print("MainViewController has been deinitialized")
    }

}




//private func setupMaskView() {
//    let maskView = UIView(frame: CGRect(x: 30, y: 60, width: 300, height: 400))
//    maskView.backgroundColor = .blue.withAlphaComponent(0.3)
//    
//    let maskLayer = CALayer()
//    maskLayer.backgroundColor = UIColor.red.cgColor
//    let xy = maskView.frame.width * 0.1
//    let width = maskView.frame.width * 0.8
//    let height = maskView.frame.height * 0.8
//    maskLayer.frame = CGRect(x: xy, y: xy, width: width, height: height)
//    
//    maskView.layer.addSublayer(maskLayer)
//    view.addSubview(maskView)
//}
