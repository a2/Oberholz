import UIKit

final class OberholzHandleView: UIView {
    private let shapeLayer = CAShapeLayer()

    var fillColor: UIColor {
        get { return shapeLayer.fillColor.map { UIColor(CGColor: $0) } ?? .blackColor() }
        set { shapeLayer.fillColor = newValue.CGColor }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit() {
        let rect = CGRect(x: 0, y: 0, width: 36, height: 5)
        shapeLayer.bounds = rect
        shapeLayer.path = CGPathCreateWithRoundedRect(rect, 2.5, 2.5, nil)
        layer.addSublayer(shapeLayer)
    }

    override func layoutSublayersOfLayer(layer: CALayer) {
        super.layoutSublayersOfLayer(layer)

        shapeLayer.position = CGPoint(x: layer.bounds.size.width / 2, y: layer.bounds.size.height / 2)
    }
}
