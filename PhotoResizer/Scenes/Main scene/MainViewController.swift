import UIKit
import PhotosUI

class MainViewController: UIViewController, InteractiveImageViewDelegate {
    
    // MARK: - Types
    
    private enum State {
        case initial
        case photoEditing(UIImage)
    }
    
    // MARK: - IBOtlets
    
    @IBOutlet var plusButtonImageView: UIImageView!
    
    // MARK: - Properties
    
    private var imageView: InteractiveImageView!
    private var cropRectangleView: CropRectangleView!
    
    private var state: State = .initial {
        didSet {
            switch state {
            case .initial:
                plusButtonImageView.isHidden = false
                if let cropRectangleView {
                    cropRectangleView.removeBorderView()
                    cropRectangleView.removeFromSuperview()
                }
                if let imageView {
                    imageView.removeFromSuperview()
                }
                view.setNeedsLayout()
            case .photoEditing(let image):
                plusButtonImageView.isHidden = true
                setupImageAndCropRectangle(image: image)
            }
        }
    }
    
    var imageRotation: CGFloat = 0.0
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupView()
    }
    
    // MARK: - Setup Methods
    
    private func setupView() {
        state = .initial
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(selectPhoto))
        plusButtonImageView.addGestureRecognizer(gesture)
    }
    
    private func setupNavigationBar() {
        
        self.setupSaveBarButtonItem()
        if let button = navigationItem.rightBarButtonItem?.customView as? UIButton {
            button.addTarget(self, action: #selector(cropImageAndSave), for: .touchUpInside)
        }
        
        self.setupResetBarButtonItem()
        if let button = navigationItem.leftBarButtonItem?.customView as? UIButton {
            button.addTarget(self, action: #selector(reset), for: .touchUpInside)
        }
    }
    
    private func setupImageAndCropRectangle(image: UIImage) {
        guard let navigationController, let windowScene = view.window?.windowScene else { return }
        let statusBarHeight = windowScene.statusBarManager?.statusBarFrame.height ?? 0
        let navigationBarHeight = navigationController.navigationBar.frame.height
        let bottomSafeAreaInset = view.safeAreaInsets.bottom
        
        cropRectangleView = CropRectangleView(
            frame: CGRect(
                x: 0,
                y: statusBarHeight + navigationBarHeight,
                width: view.frame.width,
                height: view.frame.height - navigationBarHeight - bottomSafeAreaInset
            )
        )
        view.addSubview(cropRectangleView)
        cropRectangleView.setupBorderView()
        
        let xPos = view.center.x - image.size.width / 2
        let yPos = view.center.y - image.size.height / 2
        imageView = InteractiveImageView(frame: CGRect(origin: CGPoint(x: xPos, y: yPos), size: image.size))
        imageView.delegate = self
        imageView.image = image
        view.insertSubview(imageView, at: 0)
    }
    
    // MARK: - @objc Methods
    
    @objc private func cropImageAndSave() {
        guard let imageView,
              let image = imageView.image,
              let rotatedImage = image.rotated(by: imageRotation),
              let cropFrame = cropRectangleView.cropFrame 
        else { return }
        let imageSize = rotatedImage.size
        let imageScale = rotatedImage.scale
        let maskOrigin = cropFrame.origin
        let imageOrigin = imageView.frame.origin
        
        let scaleFactor = imageSize.width * imageScale / imageView.frame.width
        
        let xCrop = (maskOrigin.x - imageOrigin.x) * scaleFactor
        let yCrop = (maskOrigin.y - imageOrigin.y) * scaleFactor
        let cropWidth = cropFrame.width * scaleFactor
        let cropHeight = cropFrame.height * scaleFactor
        
        let cropRect = CGRect(
            x: xCrop.rounded(),
            y: yCrop.rounded(),
            width: cropWidth.rounded(),
            height: cropHeight.rounded()
        )
        
        guard let croppedImage = rotatedImage.cropped(to: cropRect) else {
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(croppedImage, self, #selector(saveImage(_:didFinishSavingWithError:contextInfo:)), nil)
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
    
    @objc func reset() {
        imageRotation = 0.0
        state = .initial
    }
    
    @objc func selectPhoto() {
        plusButtonImageView.isUserInteractionEnabled = false
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
}

// MARK: - PHPicker View Controller Delegate

extension MainViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let provider = results.first?.itemProvider else { return }
        
        if provider.canLoadObject(ofClass: UIImage.self) {
            provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                DispatchQueue.main.async {
                    if let image = image as? UIImage {
                        self?.state = .photoEditing(image)
                        self?.plusButtonImageView.isUserInteractionEnabled = true
                    }
                }
            }
        }
    }
}
