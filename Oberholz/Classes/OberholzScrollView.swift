import UIKit
import UIKit.UIGestureRecognizerSubclass

extension UIGestureRecognizerState {
    var description: String {
        switch self {
        case .Possible: return "Possible"
        case .Began: return "Began"
        case .Changed: return "Changed"
        case .Ended: return "Ended"
        case .Cancelled: return "Cancelled"
        case .Failed: return "Failed"
        }
    }
}

class OberholzScrollView: UIScrollView, UIGestureRecognizerDelegate {
    var childScrollView: UIScrollView?

    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer.view == self || otherGestureRecognizer.view == self || gestureRecognizer.view == childScrollView || otherGestureRecognizer.view == childScrollView
    }

    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, withEvent: event)
        if view != self {
            return view
        } else {
            return nil
        }
    }
}
