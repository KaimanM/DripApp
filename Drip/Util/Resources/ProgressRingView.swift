import UIKit

class ProgressRingView: UIView {

    private let flatColorLayer = CAShapeLayer()
    private let shadowLayer = CAShapeLayer()
    private let gradientLayer = CAGradientLayer.conicLayer
    private let gradientMaskLayer = CAShapeLayer()
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
        setupShadowLayer()
        setupFlatColorLayer()
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
        setupShadowLayer()
        setupGradientLayers()
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

    private func setupShadowLayer() {
        layer.addSublayer(shadowLayer)
        shadowLayer.path = getPath().cgPath
        shadowLayer.lineWidth = lineWidth
        shadowLayer.strokeEnd = 1
        shadowLayer.fillColor = UIColor.clear.cgColor
        shadowLayer.strokeColor = shadowColor.cgColor
    }

    private func setupFlatColorLayer() {
        layer.addSublayer(flatColorLayer)
        flatColorLayer.path = getPath().cgPath
        flatColorLayer.lineWidth = lineWidth
        flatColorLayer.lineCap = .round
        flatColorLayer.strokeEnd = percent == 0 ? 0.001 : percent
        flatColorLayer.fillColor = UIColor.clear.cgColor
        flatColorLayer.strokeColor = strokeColour.cgColor
    }

    private func setupGradientLayers() {
        layer.addSublayer(gradientMaskLayer)
        gradientMaskLayer.path = getPath().cgPath
        gradientMaskLayer.lineWidth = lineWidth
        gradientMaskLayer.lineCap = .round
        gradientMaskLayer.strokeEnd = percent == 0 ? 0.001 : percent
        gradientMaskLayer.fillColor = UIColor.clear.cgColor
        gradientMaskLayer.strokeColor = UIColor.black.cgColor

        layer.addSublayer(gradientLayer)
        gradientLayer.colors = gradientColors.map { $0.cgColor }
        gradientLayer.frame = bounds
        gradientLayer.mask = gradientMaskLayer
    }

    private func redraw() {
        flatColorLayer.path = getPath().cgPath
        shadowLayer.path = getPath().cgPath
        gradientMaskLayer.path = getPath().cgPath

        // This allows for landscape rotation to redraw gradient
        let radius = (bounds.height/2)
        gradientLayer.frame = CGRect(x: bounds.midX-radius,
                                     y: 0,
                                     width: bounds.height,
                                     height: bounds.height)
        gradientMaskLayer.frame = CGRect(x: -(bounds.midX-radius),
                                         y: 0,
                                         width: bounds.height,
                                         height: bounds.height)
        shadowLayer.frame = CGRect(x: bounds.minX,
                                   y: 0,
                                   width: bounds.height,
                                   height: bounds.height)
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

        flatColorLayer.add(basicAnimation, forKey: "basicAnimation")
        gradientMaskLayer.add(basicAnimation, forKey: "basicAnimation")
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
        gradientLayer.startPoint = CGPoint(x: 0.5,
                                           y: 0.5001)
        gradientLayer.endPoint = CGPoint(x: 0.5,
                                         y: 0)
        return gradientLayer
    }()

}
