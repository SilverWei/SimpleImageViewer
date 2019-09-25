import UIKit
import AVFoundation
import YYWebImage

public final class ImageViewerController: UIViewController {
    @IBOutlet fileprivate var scrollView: UIScrollView!
    @IBOutlet fileprivate var imageView: YYAnimatedImageView!
    @IBOutlet fileprivate var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorImageView: UIImageView!
    @IBOutlet weak var errorMessageView: UIView!
    @IBOutlet weak var errorMessageLabel: UILabel!
    var navigationBar: NavigationBar?
    var bottomToolBar: BottomToolBar?
    
    fileprivate var transitionHandler: ImageViewerTransitioningHandler?
    fileprivate let configuration: ImageViewerConfiguration?
    
    public init(configuration: ImageViewerConfiguration?) {
        self.configuration = configuration
        super.init(nibName: String(describing: type(of: self)), bundle: Bundle(for: type(of: self)))
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        modalPresentationCapturesStatusBarAppearance = true
    }
    
    public override var prefersStatusBarHidden: Bool {
        return false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = configuration?.imageView?.image ?? configuration?.image
        
        setupNavigationBar()
        setupBottomToolBar()
        setupScrollView()
        setupGestureRecognizers()
        setupTransitions()
        setupActivityIndicator()
        setupErrorMessage()
    }
}

extension ImageViewerController: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        guard let image = imageView.image else { return }
        let imageViewSize = Utilities.aspectFitRect(forSize: image.size, insideRect: imageView.frame)
        let verticalInsets = -(scrollView.contentSize.height - max(imageViewSize.height, scrollView.bounds.height)) / 2
        let horizontalInsets = -(scrollView.contentSize.width - max(imageViewSize.width, scrollView.bounds.width)) / 2
        scrollView.contentInset = UIEdgeInsets(top: verticalInsets, left: horizontalInsets, bottom: verticalInsets, right: horizontalInsets)
    }
}

extension ImageViewerController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return scrollView.zoomScale == scrollView.minimumZoomScale
    }
}

private extension ImageViewerController {
    private func setupNavigationBar() {
        navigationBar = NavigationBar(configuration: configuration)
        navigationBar?.closeItemAction = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    private func setupBottomToolBar() {
        bottomToolBar = BottomToolBar(configuration: configuration)
    }
    
    private func setupScrollView() {
        scrollView.decelerationRate = UIScrollView.DecelerationRate.fast
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = true
    }
    
    private func setupGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.addTarget(self, action: #selector(imageViewTapped(_:)))
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        let doubleTapGestureRecognizer = UITapGestureRecognizer()
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        doubleTapGestureRecognizer.addTarget(self, action: #selector(imageViewDoubleTapped))
        imageView.addGestureRecognizer(doubleTapGestureRecognizer)
        
        tapGestureRecognizer.require(toFail: doubleTapGestureRecognizer)
        
        let panGestureRecognizer = UIPanGestureRecognizer()
        panGestureRecognizer.addTarget(self, action: #selector(imageViewPanned(_:)))
        panGestureRecognizer.delegate = self
        imageView.addGestureRecognizer(panGestureRecognizer)
    }
    
    private func setupTransitions() {
        guard let imageView = configuration?.imageView else { return }
        transitionHandler = ImageViewerTransitioningHandler(fromImageView: imageView, toImageView: self.imageView, configuration: configuration)
        transitioningDelegate = transitionHandler
    }
    
    private func setupActivityIndicator() {
        activityIndicator.startAnimating()
        navigationBar?.actionItem?.isEnabled = false
        imageView.yy_setImage(with: URL(string: configuration?.imageUrl ?? ""), placeholder: configuration?.imageView?.image ?? configuration?.image, options: [.progressiveBlur, .setImageWithFadeAnimation]) { [weak self] (image, url, fromType, stage, error) in
            self?.activityIndicator.stopAnimating()
            if image == nil {
                self?.errorImageView.isHidden = false
                self?.errorMessageView.isHidden = false
            }
            else {
                self?.navigationBar?.actionItem?.isEnabled = true
            }
        }
    }
    
    private func setupErrorMessage() {
        errorImageView.isHidden = true
        errorMessageView.isHidden = true
        
        errorMessageView.layer.rasterizationScale = UIScreen.main.scale
        errorMessageView.layer.cornerRadius = 5
        errorMessageView.layer.shadowColor = UIColor.black.cgColor
        errorMessageView.layer.shadowOffset = .zero
        errorMessageView.layer.shadowRadius = 2
        errorMessageView.layer.shadowOpacity = 0.5
        errorMessageView.layer.shouldRasterize = true
        errorMessageView.layer.rasterizationScale = UIScreen.main.scale
        errorMessageLabel.text = configuration?.errorMessage
    }
    
    @objc func imageViewTapped(_ sender: UITapGestureRecognizer) {
        navigationBar?.switchDisplay()
        bottomToolBar?.switchDisplay()
    }
    
    @objc func imageViewDoubleTapped(recognizer: UITapGestureRecognizer) {
        func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
            var zoomRect = CGRect.zero
            zoomRect.size.height = imageView.frame.size.height / scale
            zoomRect.size.width  = imageView.frame.size.width  / scale
            let newCenter = scrollView.convert(center, from: imageView)
            zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
            zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
            return zoomRect
        }

        if scrollView.zoomScale > scrollView.minimumZoomScale {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            scrollView.zoom(to: zoomRectForScale(scale: scrollView.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
        }
    }
    
    @objc func imageViewPanned(_ recognizer: UIPanGestureRecognizer) {
        guard transitionHandler != nil else { return }
            
        let translation = recognizer.translation(in: imageView)
        let velocity = recognizer.velocity(in: imageView)
        
        switch recognizer.state {
        case .began:
            transitionHandler?.dismissInteractively = true
            dismiss(animated: true)
        case .changed:
            let percentage = abs(translation.y) / imageView.bounds.height
            transitionHandler?.dismissalInteractor.update(percentage: percentage)
            transitionHandler?.dismissalInteractor.update(transform: CGAffineTransform(translationX: translation.x, y: translation.y))
        case .ended, .cancelled:
            transitionHandler?.dismissInteractively = false
            let percentage = abs(translation.y + velocity.y) / imageView.bounds.height
            if percentage > 0.25 {
                transitionHandler?.dismissalInteractor.finish()
            } else {
                transitionHandler?.dismissalInteractor.cancel()
            }
        default: break
        }
    }
}
public extension ImageViewerController {
    func set(copyUrl: String) {
        bottomToolBar?.urlLabel?.text = copyUrl
    }
}
