import UIKit

public protocol OberholzViewControllerDelegate: class {

}

public final class OberholzViewController: UIViewController, UIViewControllerTransitioningDelegate {
    public var masterViewController: UIViewController
    public var detailViewController: UIViewController

    public weak var delegate: OberholzViewControllerDelegate?
    let detailContainerView = UIView()
    var detailTopLayoutConstraint: NSLayoutConstraint?
    let handleView = OberholzHandleView()

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

        detailContainerView.addSubview(detailViewController.view)
        detailContainerView.addSubview(handleView)

        view.addSubview(detailContainerView)
        detailContainerView.frame = view.bounds.divide(100, fromEdge: .MaxYEdge).slice
        handleView.frame = detailContainerView.bounds.divide(20, fromEdge: .MinYEdge).slice
        handleView.autoresizingMask = [.FlexibleWidth, .FlexibleBottomMargin]

        detailViewController.view.frame = detailContainerView.bounds
        detailViewController.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
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
