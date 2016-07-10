import UIKit

public final class OberholzViewController: UIViewController, UIViewControllerTransitioningDelegate {
    let transitionController = OberholzTransitionController()
    let contentViewController: UIViewController
    var isInteractive = true

    public init(contentViewController: UIViewController) {
        self.contentViewController = contentViewController

        super.init(nibName: nil, bundle: nil)

        self.addChildViewController(self.contentViewController)
        self.transitioningDelegate = self.transitionController
        self.modalPresentationStyle = .Custom
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK:
    // MARK: View Life Cycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(contentViewController.view)
    }
}
