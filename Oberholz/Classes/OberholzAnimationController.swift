import UIKit

private let SpringDamping: CGFloat = 0.7
private let SpringVelocity: CGFloat = 0.7

final class OberholzAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    enum Operation {
        case Present
        case Dismiss
    }

    let operation: Operation

    init(operation: Operation) {
        self.operation = operation
    }

    func animatePresentation(transitionContext: UIViewControllerContextTransitioning) {
        guard let containerView = transitionContext.containerView() else {
            transitionContext.completeTransition(false)
            return
        }

        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        let finalToFrame = transitionContext.finalFrameForViewController(transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!)

        containerView.addSubview(toView)

        var initialToFrame = finalToFrame
        initialToFrame.origin.y = containerView.bounds.size.height
        toView.frame = initialToFrame

        let duration = transitionDuration(transitionContext)
        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: SpringDamping, initialSpringVelocity: SpringVelocity, options: [], animations: {
            toView.frame = finalToFrame
        }, completion: { finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
    }

    func animateDismissal(transitionContext: UIViewControllerContextTransitioning) {
        guard let containerView = transitionContext.containerView() else {
            transitionContext.completeTransition(false)
            return
        }

        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let initialFromFrame = transitionContext.initialFrameForViewController(transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!)

        var finalFromFrame = initialFromFrame
        finalFromFrame.origin.y = containerView.bounds.size.height

        let duration = transitionDuration(transitionContext)
        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: SpringDamping, initialSpringVelocity: SpringVelocity, options: [], animations: {
            fromView.frame = finalFromFrame
        }, completion: { finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
    }

    // MARK:
    // MARK: - Animated Transitioning

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        switch operation {
        case .Present:
            animatePresentation(transitionContext)

        case .Dismiss:
            animateDismissal(transitionContext)
        }
    }
}
