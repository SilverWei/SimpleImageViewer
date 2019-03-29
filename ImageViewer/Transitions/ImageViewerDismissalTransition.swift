import UIKit

final class ImageViewerDismissalTransition: NSObject, UIViewControllerAnimatedTransitioning {
    fileprivate weak var transitionContext: UIViewControllerContextTransitioning?
    private var configuration: ImageViewerConfiguration?
    
    fileprivate let fromImageView: UIImageView
    fileprivate var toImageView: UIImageView
    
    fileprivate var animatableImageview = AnimatableImageView()
    fileprivate var fromView: UIView?
    fileprivate var fadeView = UIView()
    fileprivate var navigationBar: NavigationBarView?
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
        
        navigationBar = NavigationBarView(view: containerVC.view, configuration: nil)
        
        if let bottomToolBar = fromVC.bottomToolBar {
            self.bottomToolBar = bottomToolBar
            containerVC.view.addSubview(bottomToolBar)
            let left = NSLayoutConstraint(item: bottomToolBar, attribute: .left, relatedBy: .equal, toItem: containerVC.view, attribute: .left, multiplier: 1.0, constant: 0.0)
            let right = NSLayoutConstraint(item: bottomToolBar, attribute: .right, relatedBy: .equal, toItem: containerVC.view, attribute: .right, multiplier: 1.0, constant: 0.0)
            let bottom = NSLayoutConstraint(item: bottomToolBar, attribute: .bottom, relatedBy: .equal, toItem: containerVC.view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
            containerVC.view.addConstraints([left, right, bottom])
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
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: apply(state: .start), completion: { _ in
            self.fromView?.isHidden = false
            self.animatableImageview.removeFromSuperview()
            self.fadeView.removeFromSuperview()
            self.navigationBar?.removeFromSuperview()
            
            let fromVC = self.transitionContext?.viewController(forKey: .from) as! ImageViewerController
            if let bottomToolBar = self.bottomToolBar {
                fromVC.view.addSubview(bottomToolBar)
                let left = NSLayoutConstraint(item: bottomToolBar, attribute: .left, relatedBy: .equal, toItem: fromVC.view, attribute: .left, multiplier: 1.0, constant: 0.0)
                let right = NSLayoutConstraint(item: bottomToolBar, attribute: .right, relatedBy: .equal, toItem: fromVC.view, attribute: .right, multiplier: 1.0, constant: 0.0)
                let bottom = NSLayoutConstraint(item: bottomToolBar, attribute: .bottom, relatedBy: .equal, toItem: fromVC.view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
                fromVC.view.addConstraints([left, right, bottom])
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
