import UIKit

public protocol OberholzViewControllerDelegate: class {
    
}

public final class OberholzViewController: UIViewController, UIViewControllerTransitioningDelegate {
    public var masterViewController: UIViewController
    public var detailViewController: UIViewController
    
    public weak var delegate: OberholzViewControllerDelegate?
    public var breakpoints: [CGFloat] = [0.1, 0.5, 0.9]
    
    let detailContainerView = UIView()
    let handleView = OberholzHandleView()
    
    var detailTopLayoutConstraint: NSLayoutConstraint?
    var detailContainerStartingFrame: CGRect?
    
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
    
    func recognizedPanGesture(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Began:
            detailContainerStartingFrame = detailContainerView.frame
            
        case .Changed:
            let translation = gesture.translationInView(gesture.view)
            var newFrame = detailContainerStartingFrame!
            let newY = newFrame.origin.y + translation.y
            
            newFrame.origin.y = newY
            newFrame.size.height = view.bounds.size.height - newFrame.origin.y
            detailContainerView.frame = newFrame
            
            if let scrollView = gesture.view as? UIScrollView {
                scrollView.contentOffset.y = newY
            }
            
        case .Ended:
            gesture.enabled = false
            gesture.enabled = true
            
            var destinationFrame = detailContainerView.frame
            
            // Find at which point of the screen the detail frame is
            let screenHeight = UIScreen.mainScreen().bounds.size.height
            let yPosition = 1 - (destinationFrame.origin.y / screenHeight)
            // Find the closest breakpoint to it
            let closest = breakpoints.enumerate().minElement({ abs($0.1 - yPosition) < abs($1.1 - yPosition)})!.element
            
            destinationFrame.origin.y = (1 - closest) * screenHeight
            destinationFrame.size.height = view.bounds.size.height - destinationFrame.origin.y

            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [], animations: {
                self.detailContainerView.frame = destinationFrame
            }, completion: nil)
            
            
        default:
            break
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
        
        detailContainerView.addSubview(detailViewController.view)
        detailContainerView.addSubview(handleView)
        
        view.addSubview(detailContainerView)
        detailContainerView.frame = view.bounds.divide(100, fromEdge: .MaxYEdge).slice
        handleView.frame = detailContainerView.bounds.divide(20, fromEdge: .MinYEdge).slice
        handleView.autoresizingMask = [.FlexibleWidth, .FlexibleBottomMargin]
        
        detailViewController.view.frame = detailContainerView.bounds
        detailViewController.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        if let scrollView = detailViewController.view as? UIScrollView {
            scrollView.contentInset.top = 20
            scrollView.contentOffset = CGPoint(x: 0, y: -20)
            scrollView.panGestureRecognizer.addTarget(self, action: #selector(recognizedPanGesture))
        } else {
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(recognizedPanGesture))
            view.addGestureRecognizer(panGesture)
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
