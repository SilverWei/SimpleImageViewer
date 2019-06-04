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
            navigationBar.addIn(vc: containerVC)
            navigationBar.alpha = 0
        }
        
        bottomToolBar = toVC.bottomToolBar
        if let bottomToolBar = bottomToolBar {
            bottomToolBar.addIn(vc: containerVC)
            bottomToolBar.alpha = 0
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
                navigationBar.addIn(vc: toVC)
            }
            
            toVC.bottomToolBar = self.bottomToolBar
            if let bottomToolBar = toVC.bottomToolBar {
                bottomToolBar.addIn(vc: toVC)
            }
        })
    }
}
