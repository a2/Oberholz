import UIKit

public final class OberholzStoryboardSegue: UIStoryboardSegue {
    public override func perform() {
        let oberholz = OberholzViewController(contentViewController: destinationViewController)
        sourceViewController.presentViewController(oberholz, animated: true, completion: nil)
    }
}
