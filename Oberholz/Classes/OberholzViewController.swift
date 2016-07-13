import UIKit

public protocol OberholzViewControllerDelegate: class {

}

public final class OberholzViewController: UIViewController, UIScrollViewDelegate, UIViewControllerTransitioningDelegate {
    public var masterViewController: UIViewController
    public var detailViewController: UIViewController

    public weak var delegate: OberholzViewControllerDelegate?
    let detailScrollView = OberholzScrollView()
    var detailTopLayoutConstraint: NSLayoutConstraint?
    let handleView = OberholzHandleView()
    var childScrollViewStartingContentOffsetY: CGFloat?
    
    public init(masterViewController: UIViewController, detailViewController: UIViewController) {
        self.masterViewController = masterViewController
        self.detailViewController = detailViewController

        super.init(nibName: nil, bundle: nil)

        self.addChildViewController(masterViewController)
        self.addChildViewController(detailViewController)
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func childScrollViewRecognizedPanGesture(gesture: UIPanGestureRecognizer) {
        let scrollView = gesture.view as! UIScrollView

        if detailScrollView.contentOffset.y <= 0 || detailScrollView.contentOffset.y >= detailScrollView.contentSize.height - detailScrollView.frame.size.height {
            if childScrollViewStartingContentOffsetY == nil {
                childScrollViewStartingContentOffsetY = scrollView.contentOffset.y
            }

            var contentOffset = scrollView.contentOffset
            contentOffset.y = childScrollViewStartingContentOffsetY! - gesture.translationInView(scrollView).y
            scrollView.setContentOffset(contentOffset, animated: false)
        } else {
            scrollView.setContentOffset(CGPoint(x: 0, y: -20), animated: false)
            gesture.setTranslation(.zero, inView: scrollView)
            childScrollViewStartingContentOffsetY = nil
        }
    }

    func detailScrollViewRecognizedPanGesture(gesture: UIPanGestureRecognizer) {
        var contentOffset = detailScrollView.contentOffset

        let changed: Bool
        let minY: CGFloat = 0
        let maxY: CGFloat = detailScrollView.contentSize.height - detailScrollView.frame.size.height

        if contentOffset.y < minY {
            contentOffset.y = minY
            changed = true
        } else if contentOffset.y > maxY {
            contentOffset.y = maxY
            changed = true
        } else {
            changed = false
        }

        if changed {
            detailScrollView.setContentOffset(contentOffset, animated: false)
        }
    }

    // MARK:
    // MARK: View Life Cycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(masterViewController.view)
        masterViewController.view.frame = view.bounds

        switch detailViewController.preferredStatusBarStyle() {
        case .LightContent:
            handleView.fillColor = UIColor(white: 1, alpha: 0.5)
        default:
            handleView.fillColor = UIColor(white: 0, alpha: 0.5)
        }

        detailScrollView.delegate = self
        detailScrollView.panGestureRecognizer.addTarget(self, action: #selector(detailScrollViewRecognizedPanGesture))
        detailScrollView.showsVerticalScrollIndicator = false
        detailScrollView.addSubview(detailViewController.view)
        detailScrollView.addSubview(handleView)

        var contentSize = view.bounds.size
        contentSize.height = 2 * contentSize.height - 140
        detailScrollView.contentSize = contentSize

        view.addSubview(detailScrollView)
        detailScrollView.frame = view.bounds

        var detailContainerFrame = view.bounds
        detailContainerFrame.origin.y = view.bounds.size.height - 100
        detailContainerFrame.size.height -= 40
        detailViewController.view.frame = detailContainerFrame
        detailViewController.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]

        handleView.autoresizingMask = [.FlexibleWidth, .FlexibleBottomMargin]
        handleView.frame = detailContainerFrame.divide(20, fromEdge: .MinYEdge).slice
        handleView.userInteractionEnabled = false

        if let scrollView = detailViewController.view as? UIScrollView {
            scrollView.contentInset.top = 20
            scrollView.contentOffset = CGPoint(x: 0, y: -20)
            scrollView.panGestureRecognizer.addTarget(self, action: #selector(childScrollViewRecognizedPanGesture))
            scrollView.addGestureRecognizer(detailScrollView.panGestureRecognizer)
            detailScrollView.childScrollView = scrollView
        } else {
            detailScrollView.childScrollView = nil
        }
    }

    public override func updateViewConstraints() {
        super.updateViewConstraints()

        if detailTopLayoutConstraint == nil {
            let isHeightConstraint: (NSLayoutConstraint) -> Bool = { constraint in
                return constraint.firstAttribute == .Height && constraint.secondAttribute == .NotAnAttribute
            }

            // THIS IS HACKZ
            // As long as we adknowledge that this is a hack, then it's fine, right?
            // At least we didn't use private APIs. ;)

            if let layoutView = detailViewController.topLayoutGuide as? UIView, constraint = layoutView.constraintsAffectingLayoutForAxis(.Vertical).lazy.filter(isHeightConstraint).first {
                detailTopLayoutConstraint = constraint
            } else if let layoutGuide = detailViewController.topLayoutGuide as? UILayoutGuide, owningView = layoutGuide.owningView, constraint = owningView.constraints.lazy.filter(isHeightConstraint).first {
                detailTopLayoutConstraint = constraint
            }

            if let constraint = detailTopLayoutConstraint {
                constraint.active = false
                detailViewController.topLayoutGuide.heightAnchor.constraintEqualToConstant(20).active = true
            }
        }
    }
}
