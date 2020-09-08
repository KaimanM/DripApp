import UIKit

class ProgressRingView: UIView {

    private let containerLayer = CALayer()
    private let flatColorLayer = CAShapeLayer()
    private let shadowLayer = CAShapeLayer()
    private var gradientLayer = CAGradientLayer()
    private let gradientMaskLayer = CAShapeLayer()

    private var secondLayer = CAGradientLayer()
    private let secondMaskLayer = CAShapeLayer()

    private var strokeColour = UIColor()
    private var gradientColors = [UIColor()]
    private var shadowColor = UIColor()
    private var lineWidth = CGFloat()
    private var currentFill = Double()
    private var currentRotation = 3*CGFloat.pi/2 // rotation of 270 degrees for shadow circle
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
        setupContainerLayer()
        setupShadowLayer()
        setupGradientLayers()
        setupCircleLayer()
        setupSecondaryGradientLayers()
        setupImageLayer()
    }

    func setProgress(_ progress: CGFloat) {
        self.percent = progress
        animateRing()
    }

    // MARK: - Private

    private func setupContainerLayer() {
        layer.addSublayer(containerLayer)
//        containerLayer.backgroundColor = UIColor.red.cgColor
    }

    private func setupImageLayer() {
        let image = UIImage(named: "icon-clear-noshadow")
        imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
    }

    private func setupCircleLayer() {
        containerLayer.addSublayer(circleContainer)
//        circleContainer.backgroundColor = UIColor.green.withAlphaComponent(0.5).cgColor

//        circle.backgroundColor = UIColor.red.cgColor
        circleContainer.addSublayer(circle)
        circle.cornerRadius = lineWidth/2
        circle.shadowRadius = 5
        circle.shadowColor = UIColor.black.cgColor
        circle.shadowOffset = CGSize(width: 5, height: 0)
        circle.shadowOpacity = 0.9
        circleContainer.opacity = 0

    }

    private func getPath() -> UIBezierPath {
        let arcCenter = CGPoint(x: containerLayer.bounds.midX, y: containerLayer.bounds.midY)
        let radius = (containerLayer.bounds.height/2) - lineWidth/2
        let circularPath = UIBezierPath(arcCenter: arcCenter,
                                        radius: radius,
                                        startAngle: -CGFloat.pi/2,
                                        endAngle: 1.5*CGFloat.pi,
                                        clockwise: true)
        return circularPath
    }

    private func getPathLast25() -> UIBezierPath {
        let arcCenter = CGPoint(x: containerLayer.bounds.midX, y: containerLayer.bounds.midY)
        let radius = (containerLayer.bounds.height/2) - lineWidth/2
        let circularPath = UIBezierPath(arcCenter: arcCenter,
                                        radius: radius,
                                        startAngle: CGFloat.pi,
                                        endAngle: 1.5*CGFloat.pi,
                                        clockwise: true)
        return circularPath
    }

    private func setupShadowLayer() {
        containerLayer.addSublayer(shadowLayer)
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

        gradientMaskLayer.path = getPath().cgPath
        gradientMaskLayer.lineWidth = lineWidth
        gradientMaskLayer.lineCap = .round
        gradientMaskLayer.strokeEnd = percent == 0 ? 0.001 : percent
        gradientMaskLayer.fillColor = UIColor.clear.cgColor
        gradientMaskLayer.strokeColor = UIColor.black.cgColor

        gradientLayer = gradientLayer.generateConicLayer()
        gradientLayer.colors = gradientColors.map { $0.cgColor }
        gradientLayer.frame = bounds

        containerLayer.addSublayer(gradientLayer)
        gradientLayer.addSublayer(gradientMaskLayer)
        gradientLayer.mask = gradientMaskLayer
    }

    private func setupSecondaryGradientLayers() {
        secondMaskLayer.path = getPathLast25().cgPath
        secondMaskLayer.lineWidth = lineWidth
        secondMaskLayer.lineCap = .round
        secondMaskLayer.strokeEnd = percent == 0 ? 0.001 : percent
        secondMaskLayer.fillColor = UIColor.clear.cgColor
        secondMaskLayer.strokeColor = UIColor.black.cgColor
        secondMaskLayer.isHidden = true

        secondLayer = secondLayer.generateConicLayer()
        secondLayer.colors = gradientColors.map { $0.cgColor }
        secondLayer.frame = bounds

        containerLayer.addSublayer(secondLayer)
        secondLayer.addSublayer(secondMaskLayer)
        secondLayer.mask = secondMaskLayer
    }

    private func redraw() {
        let radius = (bounds.height/2)
        containerLayer.frame = CGRect(x: bounds.midX-radius,
                                      y: 0,
                                      width: bounds.height,
                                      height: bounds.height)

        flatColorLayer.path = getPath().cgPath
        shadowLayer.path = getPath().cgPath
        gradientMaskLayer.path = getPath().cgPath
        secondMaskLayer.path = getPathLast25().cgPath

        // This allows for landscape rotation to redraw gradient

        gradientLayer.frame = containerLayer.bounds
        gradientMaskLayer.frame = gradientLayer.bounds

        secondLayer.frame = containerLayer.bounds
        secondMaskLayer.frame = secondLayer.bounds

        shadowLayer.frame = containerLayer.bounds
        circleContainer.frame = containerLayer.bounds

        circle.frame = CGRect(x: circleContainer.bounds.midX-lineWidth/2, y: 0, width: 30, height: 30)
        circle.shadowPath = UIBezierPath(ovalIn: circle.bounds).cgPath

        imageView.frame = CGRect(x: bounds.midX-(lineWidth*0.8*0.5),
                                 y: lineWidth*0.1,
                                 width: lineWidth*0.8,
                                 height: lineWidth*0.8)
    }

    private func animateRing() {

        CATransaction.begin()

        CATransaction.setCompletionBlock({ [weak self] in

            CATransaction.begin()

            CATransaction.setCompletionBlock({ [weak self] in
                let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
                rotationAnimation.fromValue = 2*CGFloat.pi
                rotationAnimation.toValue = (3*CGFloat.pi)
                rotationAnimation.duration = 3
                rotationAnimation.fillMode = CAMediaTimingFillMode.forwards
                rotationAnimation.isRemovedOnCompletion = false
                rotationAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
                self?.containerLayer.add(rotationAnimation, forKey: "rotation")
            })

            let basicAnimation2 = CABasicAnimation(keyPath: "strokeEnd")
            basicAnimation2.fromValue = 0
            basicAnimation2.toValue = 1
            basicAnimation2.duration = 1
            basicAnimation2.fillMode = .forwards
            basicAnimation2.isRemovedOnCompletion = false
            basicAnimation2.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)


            let opacityAnimation = CABasicAnimation(keyPath: "opacity")
            opacityAnimation.fromValue = 0
            opacityAnimation.toValue = 1
            opacityAnimation.duration = 1
            opacityAnimation.fillMode = .forwards
            opacityAnimation.isRemovedOnCompletion = false

            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotationAnimation.fromValue = self?.currentRotation
            rotationAnimation.toValue = (2*CGFloat.pi)*1
            self?.currentRotation = (2*CGFloat.pi)*self!.percent
            rotationAnimation.duration = 1
            rotationAnimation.fillMode = CAMediaTimingFillMode.forwards
            rotationAnimation.isRemovedOnCompletion = false
            rotationAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)

            self?.circleContainer.add(rotationAnimation, forKey: nil)
            self?.circleContainer.add(opacityAnimation, forKey: "opacityAnimation")
            self?.secondMaskLayer.isHidden = false
            self?.secondMaskLayer.add(basicAnimation2, forKey: "basicAnimation2")

            CATransaction.commit()

        })

        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.fromValue = currentFill
        basicAnimation.toValue = 0.75
        currentFill = Double(percent)
        basicAnimation.duration = 1
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
//        basicAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)

        flatColorLayer.add(basicAnimation, forKey: "basicAnimation")
        gradientMaskLayer.add(basicAnimation, forKey: "basicAnimation")

        CATransaction.commit()

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        redraw()
    }
}

// MARK: - Private Extensions

private extension CAGradientLayer {

    func generateConicLayer() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.type = .conic
        gradientLayer.startPoint = CGPoint(x: 0.5,
                                           y: 0.5001)
        gradientLayer.endPoint = CGPoint(x: 0.5,
                                         y: 0)
        return gradientLayer
    }
}
