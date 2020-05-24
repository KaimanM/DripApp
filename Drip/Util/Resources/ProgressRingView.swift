import UIKit

class ProgressRingView: UIView {

    private let shapeLayer = CAShapeLayer()
    private let shadowLayer = CAShapeLayer()
    private let gradientLayer = CAGradientLayer.conicLayer
    private var strokeColour = UIColor()
    private var gradientColors = [UIColor()]
    private var shadowColor = UIColor()
    private var lineWidth = CGFloat()
    private var currentFill = Double()
    private var percent: CGFloat = 0.01

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Public

    func setupRingView(progress: CGFloat,
                       colour: UIColor,
                       shadowColour: UIColor,
                       lineWidth: CGFloat) {
        self.strokeColour = colour
        self.shadowColor = shadowColour
        self.lineWidth = lineWidth
        self.percent = progress
        setupShapeShadowLayers()
    }

    func setupGradientRingView(progress: CGFloat,
                               firstColour: UIColor,
                               secondColour: UIColor,
                               shadowColour: UIColor,
                               lineWidth: CGFloat) {
        self.shadowColor = shadowColour
        self.lineWidth = lineWidth
        self.percent = progress
        self.gradientColors = [firstColour,
                               firstColour,
                               secondColour,
                               secondColour,
                               firstColour]
        self.strokeColour = .black
        setupShapeShadowLayers()
        setupGradientLayer()
    }

    func setProgress(_ progress: CGFloat) {
        self.percent = progress
        animateRing()
    }

    // MARK: - Private

    private func getPath() -> UIBezierPath {
        let arcCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = (bounds.height/2) - lineWidth/2
        let circularPath = UIBezierPath(arcCenter: arcCenter,
                                        radius: radius,
                                        startAngle: -CGFloat.pi/2,
                                        endAngle: 1.5*CGFloat.pi,
                                        clockwise: true)
        return circularPath
    }

    private func setupShapeShadowLayers() {
        layer.addSublayer(shadowLayer)
        layer.addSublayer(shapeLayer)

        shapeLayer.path = getPath().cgPath
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineCap = .round
        shapeLayer.strokeEnd = percent == 0 ? 0.001 : percent
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = strokeColour.cgColor

        shadowLayer.path = getPath().cgPath
        shadowLayer.lineWidth = lineWidth
        shadowLayer.strokeEnd = 1
        shadowLayer.fillColor = UIColor.clear.cgColor
        shadowLayer.strokeColor = shadowColor.cgColor
    }

    private func setupGradientLayer() {
        layer.addSublayer(gradientLayer)
        gradientLayer.colors = gradientColors.map { $0.cgColor }
        gradientLayer.frame = bounds

        let mask = CAShapeLayer()
        mask.fillColor = UIColor.clear.cgColor
        mask.strokeColor = UIColor.yellow.cgColor
        mask.lineWidth = 25
        mask.path = getPath().cgPath
        gradientLayer.mask = shapeLayer
    }

    private func redraw() {
        shapeLayer.path = getPath().cgPath
        shapeLayer.lineWidth = lineWidth
        shadowLayer.path = getPath().cgPath
        shadowLayer.lineWidth = lineWidth
        shadowLayer.allowsEdgeAntialiasing = true
        shapeLayer.allowsEdgeAntialiasing = true

        // This allows for landscape rotation to redraw gradient
        let radius = (bounds.height/2)
        gradientLayer.frame = CGRect(x: bounds.midX-radius, y: 0, width: bounds.height, height: bounds.height)
        shapeLayer.frame = CGRect(x: -(bounds.midX-radius), y: 0, width: bounds.height, height: bounds.height)
    }

    private func animateRing() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")

        basicAnimation.fromValue = currentFill
        basicAnimation.toValue = percent
        currentFill = Double(percent)
        basicAnimation.duration = 2.25
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        basicAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)

        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        redraw()
    }
}

// MARK: - Private Extensions

private extension CAGradientLayer {

    static var conicLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.type = .conic
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        return gradientLayer
    }()

}
