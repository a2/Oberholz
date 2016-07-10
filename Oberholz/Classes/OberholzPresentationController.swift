import UIKit

private extension UIEdgeInsets {
    func inset(rect: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(rect, self)
    }
}

final class OberholzPresentationController: UIPresentationController {
    var contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

    let dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()

    override func frameOfPresentedViewInContainerView() -> CGRect {
        guard let containerView = containerView else {
            return .zero
        }

        let availableFrame = contentInset.inset(containerView.bounds)

        var height = presentedViewController.preferredContentSize.height
        if height == 0 {
            height = availableFrame.size.height / 2
        }

        if height < availableFrame.size.height {
            return availableFrame.divide(height, fromEdge: .MaxYEdge).slice
        } else {
            return availableFrame
        }
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()

        if let containerView = containerView where dimmingView.superview == containerView {
            dimmingView.frame = containerView.bounds
        }
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()

        guard let containerView = containerView, transitionCoordinator = presentedViewController.transitionCoordinator() else {
            return
        }

        dimmingView.alpha = 0
        containerView.addSubview(dimmingView)

        transitionCoordinator.animateAlongsideTransition({ context in
            self.dimmingView.alpha = 1
        }, completion: nil)
    }

    override func presentationTransitionDidEnd(completed: Bool) {
        super.presentationTransitionDidEnd(completed)
    }

    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()

        let transitionCoordinator = presentedViewController.transitionCoordinator()
        transitionCoordinator?.animateAlongsideTransition({ context in
            self.dimmingView.alpha = 0
        }, completion: nil)
    }

    override func dismissalTransitionDidEnd(completed: Bool) {
        super.dismissalTransitionDidEnd(completed)

        if completed {
            dimmingView.removeFromSuperview()
        }
    }
}
