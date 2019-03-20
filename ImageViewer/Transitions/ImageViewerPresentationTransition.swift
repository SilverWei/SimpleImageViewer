import UIKit

final class ImageViewerPresentationTransition: NSObject, UIViewControllerAnimatedTransitioning {
    private let fromImageView: UIImageView
    
    init(fromImageView: UIImageView) {
        self.fromImageView = fromImageView
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let containerVC = transitionContext.viewController(forKey: .from)!
        let toView = transitionContext.view(forKey: .to)!
        let fromParentView = fromImageView.superview!

        let imageView = AnimatableImageView()
        imageView.image = fromImageView.image
        imageView.frame = fromParentView.convert(fromImageView.frame, to: nil)
        imageView.contentMode = fromImageView.contentMode
        
        let navigationBar = NavigationBarView(view: containerVC.view, configuration: nil)
        navigationBar.alpha = 0.0
        
        let fadeView = UIView(frame: containerView.bounds)
        fadeView.backgroundColor = .black
        fadeView.alpha = 0.0
        containerVC.view.addSubview(fadeView)
        containerVC.view.addSubview(imageView)
        containerVC.view.bringSubviewToFront(navigationBar)
        
        toView.frame = containerView.bounds
        toView.isHidden = true
        fromImageView.isHidden = true
        
        containerView.addSubview(toView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut,  animations: {
            imageView.contentMode = .scaleAspectFit
            imageView.frame = containerView.bounds
            fadeView.alpha = 1.0
            navigationBar.alpha = 1.0
        }, completion: { _ in
            toView.isHidden = false
            fadeView.removeFromSuperview()
            navigationBar.removeFromSuperview()
            imageView.removeFromSuperview()
            transitionContext.completeTransition(true)
        })
    }
}
