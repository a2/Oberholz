import UIKit

final class OberholzTransitionController: NSObject, UIViewControllerTransitioningDelegate {
    // MARK:
    // MARK: Transitioning Delegate

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        if let oberholz = presented as? OberholzViewController where oberholz.isInteractive {
//            presenting.view.addGestureRecognizer(gestureRecognizer)
//        }

        return OberholzAnimationController(operation: .Present)
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return OberholzAnimationController(operation: .Dismiss)
    }

    /*
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if let interactionController = self.interactionController {
            return interactionController
        } else {
            let interactionController = UIPercentDrivenInteractiveTransition()
            self.interactionController = interactionController
            return interactionController
        }
    }

    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if let interactionController = self.interactionController {
            return interactionController
        } else {
            let interactionController = UIPercentDrivenInteractiveTransition()
            self.interactionController = interactionController
            return interactionController
        }
    }
    */

    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return OberholzPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }
}
