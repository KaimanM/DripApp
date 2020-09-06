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
    private var currentRotation = CGFloat()
    private var percent: CGFloat = 0.01
    private var imageView = UIImageView()
    private var circleContainer = CALayer()
    private var circle = CAShapeLayer()

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
        setupCircleLayer()
        setupGradientLayers()
        setupImageLayer()
    }

    func setProgress(_ progress: CGFloat) {
        self.percent = progress
        animateRing()
    }

    // MARK: - Private

    private func setupImageLayer() {
        let image = UIImage(named: "icon-clear-noshadow")
        imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
    }

    private func setupCircleLayer() {
        layer.addSublayer(circleContainer)
//        circleContainer.backgroundColor = UIColor.green.withAlphaComponent(0.5).cgColor


//        circle.backgroundColor = UIColor.red.cgColor
        circleContainer.addSublayer(circle)
        circle.cornerRadius = lineWidth/2
        circle.shadowRadius = 5
        circle.shadowColor = UIColor.black.cgColor
        circle.shadowOffset = CGSize(width: 5, height: 0)
        circle.shadowOpacity = 0.9

    }

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
        imageView.frame = CGRect(x: bounds.midX-(lineWidth*0.8*0.5),
                                 y: lineWidth*0.1,
                                 width: lineWidth*0.8,
                                 height: lineWidth*0.8)

        circleContainer.frame = CGRect(x: bounds.midX-radius,
                                       y: 0,
                                       width: bounds.height,
                                       height: bounds.height)

        circle.frame = CGRect(x: circleContainer.bounds.midX-lineWidth/2, y: 0, width: 30, height: 30)

        circle.shadowPath = UIBezierPath(ovalIn: circle.bounds).cgPath
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

        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = currentRotation
        rotationAnimation.toValue = (2*CGFloat.pi)*percent
        currentRotation = (2*CGFloat.pi)*percent
        rotationAnimation.duration = 2.25
        rotationAnimation.fillMode = CAMediaTimingFillMode.forwards
        rotationAnimation.isRemovedOnCompletion = false
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        circleContainer.add(rotationAnimation, forKey: nil)

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
