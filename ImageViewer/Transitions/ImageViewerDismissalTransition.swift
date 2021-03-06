import UIKit

final class ImageViewerDismissalTransition: NSObject, UIViewControllerAnimatedTransitioning {
    fileprivate weak var transitionContext: UIViewControllerContextTransitioning?
    private var configuration: ImageViewerConfiguration?
    
    fileprivate let fromImageView: UIImageView
    fileprivate var toImageView: UIImageView
    
    fileprivate var animatableImageview = AnimatableImageView()
    fileprivate var fromView: UIView?
    fileprivate var fadeView = UIView()
    fileprivate var navigationBar: NavigationBar?
    fileprivate var bottomToolBar: BottomToolBar?
    
    enum TransitionState {
        case start
        case end
    }
    
    fileprivate var translationTransform: CGAffineTransform = CGAffineTransform.identity {
        didSet { updateTransform() }
    }
    
    fileprivate var scaleTransform: CGAffineTransform = CGAffineTransform.identity {
        didSet { updateTransform() }
    }
    
    init(fromImageView: UIImageView, toImageView: UIImageView, configuration: ImageViewerConfiguration?) {
        self.fromImageView = fromImageView
        self.toImageView = toImageView
        self.configuration = configuration
        super.init()
    }
    
    func update(transform: CGAffineTransform) {
        translationTransform = transform
    }
    
    func update(percentage: CGFloat) {
        let invertedPercentage = 1.0 - percentage
        fadeView.alpha = invertedPercentage
        navigationBar?.alpha = invertedPercentage
        navigationBar?.transform = CGAffineTransform(translationX: 0, y: -1 * (200 - (invertedPercentage * 200)))
        bottomToolBar?.alpha = invertedPercentage
        bottomToolBar?.transform = CGAffineTransform(translationX: 0, y: 200 - (invertedPercentage * 200))
        scaleTransform = CGAffineTransform(scaleX: invertedPercentage, y: invertedPercentage)
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        start(transitionContext)
        finish()
    }

    func start(_ transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        self.fromView = transitionContext.view(forKey: .from)!
        let containerView = transitionContext.containerView
        let containerVC = transitionContext.viewController(forKey: .to)!
        let fromSuperView = fromImageView.superview!
        let fromVC = transitionContext.viewController(forKey: .from) as! ImageViewerController
        let image = fromImageView.image ?? toImageView.image
        
        animatableImageview.image = image
        animatableImageview.frame = fromSuperView.convert(fromImageView.frame, to: nil)
        animatableImageview.contentMode = .scaleAspectFit
        
        fromView?.isHidden = true
        
        navigationBar = fromVC.navigationBar
        if let navigationBar = navigationBar {
            navigationBar.addIn(vc: containerVC)
        }
        
        bottomToolBar = fromVC.bottomToolBar
        if let bottomToolBar = bottomToolBar {
            bottomToolBar.addIn(vc: containerVC)
        }
        
        fadeView.frame = containerView.bounds
        fadeView.backgroundColor = .black
        containerVC.view.addSubview(fadeView)
        containerVC.view.addSubview(animatableImageview)
        containerVC.view.bringSubviewToFront(navigationBar!)
        containerVC.view.bringSubviewToFront(bottomToolBar!)
    }
    
    func cancel() {
        transitionContext?.cancelInteractiveTransition()
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: apply(state: .start), completion: { [weak self] _ in
            guard let `self` = self else { return }
            self.fromView?.isHidden = false
            self.animatableImageview.removeFromSuperview()
            self.fadeView.removeFromSuperview()
            
            let fromVC = self.transitionContext?.viewController(forKey: .from) as! ImageViewerController
            if let navigationBar = self.navigationBar {
                navigationBar.addIn(vc: fromVC)
            }
            if let bottomToolBar = self.bottomToolBar {
                bottomToolBar.addIn(vc: fromVC)
            }
            
            self.transitionContext?.completeTransition(false)
            
        })
    }
    
    func finish() {
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: apply(state: .end), completion: { _ in
            self.toImageView.isHidden = false
            self.fadeView.removeFromSuperview()
            self.navigationBar?.removeFromSuperview()
            self.bottomToolBar?.removeFromSuperview()
            self.animatableImageview.removeFromSuperview()
            self.fromView?.removeFromSuperview()
            self.transitionContext?.completeTransition(true)
            self.configuration?.finish_action?()
        })
    }
}

private extension ImageViewerDismissalTransition {
    func updateTransform() {
        animatableImageview.transform = scaleTransform.concatenating(translationTransform)
    }
    
    func apply(state: TransitionState) -> () -> Void  {
        return {
            switch state {
            case .start:
                self.animatableImageview.contentMode = .scaleAspectFit
                self.animatableImageview.transform = .identity
                self.animatableImageview.frame = self.fromImageView.frame
                self.fadeView.alpha = 1.0
                self.navigationBar?.alpha = 1.0
                self.navigationBar?.transform = CGAffineTransform(translationX: 0, y: 0)
                self.bottomToolBar?.alpha = 1.0
                self.bottomToolBar?.transform = CGAffineTransform(translationX: 0, y: 0)
            case .end:
                self.animatableImageview.contentMode = self.toImageView.contentMode
                self.animatableImageview.transform = .identity
                self.animatableImageview.frame = self.toImageView.superview!.convert(self.toImageView.frame, to: nil)
                self.fadeView.alpha = 0.0
                self.navigationBar?.alpha = 0.0
                self.navigationBar?.transform = CGAffineTransform(translationX: 0, y: -200)
                self.bottomToolBar?.alpha = 0.0
                self.bottomToolBar?.transform = CGAffineTransform(translationX: 0, y: 200)
            }
        }
    }
}
