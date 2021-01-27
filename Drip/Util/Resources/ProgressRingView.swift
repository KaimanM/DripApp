import UIKit

class ProgressRingView: UIView {

    private let containerLayer = CALayer()
    private let flatColorLayer = CAShapeLayer()
    private let shadowLayer = CAShapeLayer()
    private var gradientLayer1 = CAGradientLayer()
    private let gradientMaskPart1 = CAShapeLayer()

    private var gradientLayer2 = CAGradientLayer()
    private let gradientMaskPart2 = CAShapeLayer()

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
    private var timings = Timings()

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
        setupGradientPart1()
        setupCircleLayer()
        setupGradientPart2()
        setupImageLayer()
    }

    func setProgress(_ progress: CGFloat) {
        self.percent = progress
        animateRing()
    }

    // MARK: - Private

    struct Timings {
        var time1: Double = 0
        var time2: Double = 0
        var time3: Double = 0
    }

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

    private func setupGradientPart1() {
        gradientMaskPart1.path = getPath().cgPath
        gradientMaskPart1.lineWidth = lineWidth
        gradientMaskPart1.lineCap = .round
        gradientMaskPart1.strokeEnd = percent == 0 ? 0.001 : percent
        gradientMaskPart1.fillColor = UIColor.clear.cgColor
        gradientMaskPart1.strokeColor = UIColor.black.cgColor

        gradientLayer1 = gradientLayer1.generateConicLayer()
        gradientLayer1.colors = gradientColors.map { $0.cgColor }
        gradientLayer1.frame = bounds

        containerLayer.addSublayer(gradientLayer1)
        gradientLayer1.addSublayer(gradientMaskPart1)
        gradientLayer1.mask = gradientMaskPart1
    }

    private func setupGradientPart2() {
        gradientMaskPart2.path = getPathLast25().cgPath
        gradientMaskPart2.lineWidth = lineWidth
        gradientMaskPart2.lineCap = .round
        gradientMaskPart2.strokeEnd = percent == 0 ? 0.001 : percent
        gradientMaskPart2.fillColor = UIColor.clear.cgColor
        gradientMaskPart2.strokeColor = UIColor.black.cgColor
//        gradientMaskPart2.isHidden = true
        gradientMaskPart2.opacity = 0

        gradientLayer2 = gradientLayer2.generateConicLayer()
        gradientLayer2.colors = gradientColors.map { $0.cgColor }
        gradientLayer2.frame = bounds

        containerLayer.addSublayer(gradientLayer2)
        gradientLayer2.addSublayer(gradientMaskPart2)
        gradientLayer2.mask = gradientMaskPart2
    }

    private func redraw() {
        let radius = (bounds.height/2)
        containerLayer.frame = CGRect(x: bounds.midX-radius,
                                      y: 0,
                                      width: bounds.height,
                                      height: bounds.height)

        flatColorLayer.path = getPath().cgPath
        shadowLayer.path = getPath().cgPath
        gradientMaskPart1.path = getPath().cgPath
        gradientMaskPart2.path = getPathLast25().cgPath

        // This allows for landscape rotation to redraw gradient

        gradientLayer1.frame = containerLayer.bounds
        gradientMaskPart1.frame = gradientLayer1.bounds

        gradientLayer2.frame = containerLayer.bounds
        gradientMaskPart2.frame = gradientLayer2.bounds

        shadowLayer.frame = containerLayer.bounds
        circleContainer.frame = containerLayer.bounds

        circle.frame = CGRect(x: circleContainer.bounds.midX-lineWidth/2, y: 0, width: 30, height: 30)
        circle.shadowPath = UIBezierPath(ovalIn: circle.bounds).cgPath

        imageView.frame = CGRect(x: bounds.midX-(lineWidth*0.8*0.5),
                                 y: lineWidth*0.1,
                                 width: lineWidth*0.8,
                                 height: lineWidth*0.8)
    }

//    private func animateRing() {
//
//        let needsMultipleAnimations = percent <= 0.75 ? false : true
//
//        CATransaction.begin()
//
//        if needsMultipleAnimations { CATransaction.setCompletionBlock(ringEndAnimation) }
//
//        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
//        basicAnimation.fromValue = currentFill
//        basicAnimation.toValue = percent > 0.75 ? 0.75 : percent
//        currentFill = Double(percent)
//        basicAnimation.fillMode = .forwards
//        basicAnimation.isRemovedOnCompletion = false
//        basicAnimation.duration = needsMultipleAnimations ? 1 : 2.25
//        basicAnimation.timingFunction =
//            needsMultipleAnimations ? .none : CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
//
//        flatColorLayer.add(basicAnimation, forKey: "basicAnimation")
//        gradientMaskPart1.add(basicAnimation, forKey: "basicAnimation")
//
//        CATransaction.commit()
//
//    }

    private func animateRing() {

        timings.time1 = Double(percent > 0.75 ? ((0.75/percent)*2) : 2)
        timings.time2 = Double(percent > 1 ? ((0.25/percent)*2) : (percent-0.75)*2)
        timings.time3 = Double((percent-1)/percent * 2)

        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.fromValue = currentFill
        basicAnimation.toValue = percent > 0.75 ? 0.75 : percent
        currentFill = Double(percent)
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        basicAnimation.duration = timings.time1
//        basicAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)

        flatColorLayer.add(basicAnimation, forKey: "basicAnimation")
        gradientMaskPart1.add(basicAnimation, forKey: "basicAnimation")

        let needsMultipleAnimations = percent <= 0.75 ? false : true

        if needsMultipleAnimations {ringEndAnimation()}

    }

    private func ringEndAnimation() {

//        let duration: Double = 0.33
//        let timingFunction: CAMediaTimingFunction? = CAMediaTimingFunction(name: .easeOut)

        let basicAnimation2 = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation2.fromValue = 0
        basicAnimation2.toValue = percent <= 1 ? (percent-0.75)*4 : 1

        basicAnimation2.beginTime = CACurrentMediaTime() + timings.time1
        basicAnimation2.duration = timings.time2
        basicAnimation2.fillMode = .forwards
        basicAnimation2.isRemovedOnCompletion = false
//        basicAnimation2.timingFunction = timingFunction

        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 0
        opacityAnimation.toValue = 1
        opacityAnimation.beginTime = CACurrentMediaTime() + timings.time1
        opacityAnimation.duration = timings.time2
        opacityAnimation.fillMode = .forwards
        opacityAnimation.isRemovedOnCompletion = false

        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = self.currentRotation
        rotationAnimation.toValue = (2*CGFloat.pi)*(percent <= 1 ? percent : 1)
        self.currentRotation = (2*CGFloat.pi)*(percent <= 1 ? percent : 1)
        rotationAnimation.beginTime = CACurrentMediaTime() + timings.time1
        rotationAnimation.duration = timings.time2
        rotationAnimation.fillMode = CAMediaTimingFillMode.forwards
        rotationAnimation.isRemovedOnCompletion = false
//        rotationAnimation.timingFunction = timingFunction

        let opacityAni2 = CABasicAnimation(keyPath: "opacity")
        opacityAni2.fromValue = 0
        opacityAni2.toValue = 1
        opacityAni2.beginTime = CACurrentMediaTime() + timings.time1
        opacityAni2.duration = 0.01
        opacityAni2.fillMode = .forwards
        opacityAni2.isRemovedOnCompletion = false

        self.circleContainer.add(rotationAnimation, forKey: nil)
        self.circleContainer.add(opacityAnimation, forKey: "opacityAnimation")
//        self.gradientMaskPart2.isHidden = false
        self.gradientMaskPart2.add(opacityAni2, forKey: "opacityAnimation")
        self.gradientMaskPart2.add(basicAnimation2, forKey: "basicAnimation2")

        let needsMultipleAnimations = percent <= 1 ? false : true

        if needsMultipleAnimations { rotateRingAnimation()}
    }

//    private func ringEndAnimation() {
//
//        let needsMultipleAnimations = percent <= 1 ? false : true
//
//        CATransaction.begin()
//
//        if needsMultipleAnimations { CATransaction.setCompletionBlock(rotateRingAnimation) }
//
//        let duration = needsMultipleAnimations ? 1 : 1.25
//        let timingFunction: CAMediaTimingFunction? =
//            needsMultipleAnimations ? .none : CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
//
//        let basicAnimation2 = CABasicAnimation(keyPath: "strokeEnd")
//        basicAnimation2.fromValue = 0
//        basicAnimation2.toValue = percent <= 1 ? (percent-0.75)*4 : 1
//
//        basicAnimation2.duration = duration
//        basicAnimation2.fillMode = .forwards
//        basicAnimation2.isRemovedOnCompletion = false
//        basicAnimation2.timingFunction = timingFunction
//
//        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
//        opacityAnimation.fromValue = 0
//        opacityAnimation.toValue = 1
//        opacityAnimation.duration = duration
//        opacityAnimation.fillMode = .forwards
//        opacityAnimation.isRemovedOnCompletion = false
//
//        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
//        rotationAnimation.fromValue = self.currentRotation
//        rotationAnimation.toValue = (2*CGFloat.pi)*(percent <= 1 ? percent : 1)
//        self.currentRotation = (2*CGFloat.pi)*(percent <= 1 ? percent : 1)
//        rotationAnimation.duration = duration
//        rotationAnimation.fillMode = CAMediaTimingFillMode.forwards
//        rotationAnimation.isRemovedOnCompletion = false
//        rotationAnimation.timingFunction = timingFunction
//
//        self.circleContainer.add(rotationAnimation, forKey: nil)
//        self.circleContainer.add(opacityAnimation, forKey: "opacityAnimation")
//        self.gradientMaskPart2.isHidden = false
//        self.gradientMaskPart2.add(basicAnimation2, forKey: "basicAnimation2")
//
//        CATransaction.commit()
//    }

    private func rotateRingAnimation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 2*CGFloat.pi
        rotationAnimation.toValue = 2*CGFloat.pi+((2*(percent-1)*CGFloat.pi))
        rotationAnimation.beginTime = CACurrentMediaTime() + timings.time1 + timings.time2
        rotationAnimation.duration = timings.time3
        rotationAnimation.fillMode = CAMediaTimingFillMode.forwards
        rotationAnimation.isRemovedOnCompletion = false
//        rotationAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        self.containerLayer.add(rotationAnimation, forKey: "rotation")
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
