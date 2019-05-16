import UIKit

final class ImageViewerPresentationTransition: NSObject, UIViewControllerAnimatedTransitioning {
    private let fromImageView: UIImageView
    private var configuration: ImageViewerConfiguration?
    private var navigationBar: NavigationBar?
    private var bottomToolBar: BottomToolBar?
    
    init(fromImageView: UIImageView, configuration: ImageViewerConfiguration?) {
        self.fromImageView = fromImageView
        self.configuration = configuration
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let containerVC = transitionContext.viewController(forKey: .from)!
        let toView = transitionContext.view(forKey: .to)!
        let toVC = transitionContext.viewController(forKey: .to) as! ImageViewerController
        let fromParentView = fromImageView.superview!

        let imageView = AnimatableImageView()
        imageView.image = fromImageView.image
        imageView.frame = fromParentView.convert(fromImageView.frame, to: nil)
        imageView.contentMode = fromImageView.contentMode
        
        let fadeView = UIView(frame: containerView.bounds)
        fadeView.backgroundColor = .black
        fadeView.alpha = 0.0
        containerVC.view.addSubview(fadeView)
        containerVC.view.addSubview(imageView)
        
        
        navigationBar = toVC.navigationBar
        if let navigationBar = navigationBar {
            containerVC.view.addSubview(navigationBar)
            let top = NSLayoutConstraint(item: navigationBar, attribute: .top, relatedBy: .equal, toItem: containerVC.view, attribute: .top, multiplier: 1.0, constant: 0.0)
            let left = NSLayoutConstraint(item: navigationBar, attribute: .left, relatedBy: .equal, toItem: containerVC.view, attribute: .left, multiplier: 1.0, constant: 0.0)
            let right = NSLayoutConstraint(item: navigationBar, attribute: .right, relatedBy: .equal, toItem: containerVC.view, attribute: .right, multiplier: 1.0, constant: 0.0)
            containerVC.view.addConstraints([top, left, right])
            containerVC.view.bringSubviewToFront(navigationBar)
            navigationBar.alpha = 0.0
        }
        
        
        bottomToolBar = toVC.bottomToolBar
        if let bottomToolBar = bottomToolBar {
            containerVC.view.addSubview(bottomToolBar)
            let left = NSLayoutConstraint(item: bottomToolBar, attribute: .left, relatedBy: .equal, toItem: containerVC.view, attribute: .left, multiplier: 1.0, constant: 0.0)
            let right = NSLayoutConstraint(item: bottomToolBar, attribute: .right, relatedBy: .equal, toItem: containerVC.view, attribute: .right, multiplier: 1.0, constant: 0.0)
            let bottom = NSLayoutConstraint(item: bottomToolBar, attribute: .bottom, relatedBy: .equal, toItem: containerVC.view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
            containerVC.view.addConstraints([left, right, bottom])
            containerVC.view.bringSubviewToFront(bottomToolBar)
            bottomToolBar.alpha = 0.0
        }
        
        toView.frame = containerView.bounds
        toView.isHidden = true
        fromImageView.isHidden = true
        
        containerView.addSubview(toView)
        
        navigationBar?.transform = CGAffineTransform(translationX: 0, y: -200)
        bottomToolBar?.transform = CGAffineTransform(translationX: 0, y: 200)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut,  animations: { [weak self] in
            imageView.contentMode = .scaleAspectFit
            imageView.frame = containerView.bounds
            fadeView.alpha = 1.0
            self?.navigationBar?.alpha = 1.0
            self?.bottomToolBar?.alpha = 1.0
            self?.navigationBar?.transform = CGAffineTransform(translationX: 0, y: 0)
            self?.bottomToolBar?.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: { [weak self] _ in
            guard let `self` = self else { return }
            toView.isHidden = false
            fadeView.removeFromSuperview()
            self.navigationBar?.removeFromSuperview()
            imageView.removeFromSuperview()
            transitionContext.completeTransition(true)
            
            toVC.navigationBar = self.navigationBar
            if let navigationBar = toVC.navigationBar {
                toVC.view.addSubview(navigationBar)
                let top = NSLayoutConstraint(item: navigationBar, attribute: .top, relatedBy: .equal, toItem: toVC.view, attribute: .top, multiplier: 1.0, constant: 0.0)
                let left = NSLayoutConstraint(item: navigationBar, attribute: .left, relatedBy: .equal, toItem: toVC.view, attribute: .left, multiplier: 1.0, constant: 0.0)
                let right = NSLayoutConstraint(item: navigationBar, attribute: .right, relatedBy: .equal, toItem: toVC.view, attribute: .right, multiplier: 1.0, constant: 0.0)
                toVC.view.addConstraints([top, left, right])
            }
            
            toVC.bottomToolBar = self.bottomToolBar
            if let bottomToolBar = toVC.bottomToolBar {
                toVC.view.addSubview(bottomToolBar)
                let left = NSLayoutConstraint(item: bottomToolBar, attribute: .left, relatedBy: .equal, toItem: toVC.view, attribute: .left, multiplier: 1.0, constant: 0.0)
                let right = NSLayoutConstraint(item: bottomToolBar, attribute: .right, relatedBy: .equal, toItem: toVC.view, attribute: .right, multiplier: 1.0, constant: 0.0)
                let bottom = NSLayoutConstraint(item: bottomToolBar, attribute: .bottom, relatedBy: .equal, toItem: toVC.view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
                toVC.view.addConstraints([left, right, bottom])
            }
        })
    }
}
