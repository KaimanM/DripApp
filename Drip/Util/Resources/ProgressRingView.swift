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
    private var currentFill = CGFloat()
    private var currentShadowRotation = 3*CGFloat.pi/2 // rotation of 270 degrees for shadow circle
    private var percent: CGFloat = 0.01
    private var imageView = UIImageView()
    private var circleContainer = CALayer()
    private var circle = CAShapeLayer()
    private var timings = Timings()

    private var ring1CurrentFill = CGFloat()
    private var ring1TartgetFill = CGFloat()
    private var ring2CurrentFill = CGFloat()
    private var ring2TargetFill = CGFloat()
    private var ring3CurrentRotation: CGFloat = 2*CGFloat.pi
    private var ring3TargetRotation = CGFloat()

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
        calculateTiming()
        currentFill = percent
    }

    // MARK: - Private

    struct Timings {
        var totalDuration: Double = 2
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

    // swiftlint:disable:next function_body_length
    private func calculateTiming() {
        timings.totalDuration = 2
        timings.time1 = 0
        timings.time2 = 0
        timings.time3 = 0
        let oldProgress = Double(currentFill)
        let newProgress = Double(percent)
        let delta = abs(Double(newProgress - oldProgress))

        switch oldProgress {
        case 0...0.75: // Animation begins in ring 1
            if newProgress < 0.75 { // do we need less than or equal to?
                timings.time1 = 1
            } else if newProgress <= 1 {
                timings.time1 = (0.75-oldProgress)/delta
                timings.time2 = ((newProgress)-0.75)/delta
            } else {
                timings.time1 = (0.75-oldProgress)/delta
                timings.time2 = 0.25/delta
                timings.time3 = (newProgress-1)/delta
            }
        case 0.75...1: // Animation begins in ring 2
            if (0.75...1).contains(newProgress) {
                timings.time2 = 1
            } else if newProgress < 0.75 {
                timings.time1 = (0.75-newProgress)/delta
                timings.time2 = (oldProgress-0.75)/delta
            } else {
                timings.time2 = (1-oldProgress)/delta
                timings.time3 = (newProgress-1)/delta
            }
        case 1...Double.greatestFiniteMagnitude: // Animation begins in ring 3
            if newProgress >= 1 {
                timings.time3 = 1
            } else if (0.75...1).contains(newProgress) {
                timings.time2 = (1-newProgress)/delta
                timings.time3 = (oldProgress-1)/delta
            } else {
                timings.time1 = (0.75-newProgress)/delta
                timings.time2 = 0.25/delta
                timings.time3 = (oldProgress-1)/delta
            }
        default:
          print("Other")
        }

        timings.time1 *= timings.totalDuration
        timings.time2 *= timings.totalDuration
        timings.time3 *= timings.totalDuration

        chooseStartingRing()
    }

    private func chooseStartingRing() {
        if currentFill <= 0.75 {
            animateRing()
        } else if currentFill <= 1 {
            ringEndAnimation()
        } else {
            rotateRingAnimation()
        }
    }

    private func animateRing() {
        let ringFillAnimation = CABasicAnimation(keyPath: "strokeEnd")
        ringFillAnimation.fromValue = ring1CurrentFill
        ring1TartgetFill = percent > 0.75 ? 0.75 : percent
        ringFillAnimation.toValue = ring1TartgetFill
        ring1CurrentFill = ring1TartgetFill
        ringFillAnimation.fillMode = .both
        ringFillAnimation.isRemovedOnCompletion = false
        ringFillAnimation.duration = timings.time1

        if (currentFill > 1) {
            ringFillAnimation.beginTime = CACurrentMediaTime() + timings.time2 + timings.time3
        } else if currentFill > 0.75 {
            ringFillAnimation.beginTime = CACurrentMediaTime() + timings.time2
        }

        flatColorLayer.add(ringFillAnimation, forKey: "basicAnimation")
        gradientMaskPart1.add(ringFillAnimation, forKey: "basicAnimation")

        if percent > 0.75 {ringEndAnimation()}
    }

    // swiftlint:disable:next function_body_length
    private func ringEndAnimation() {
        // Animation Declarations
        let ringFillAnimation = CABasicAnimation(keyPath: "strokeEnd")
        let ringOpacityAnimation = CABasicAnimation(keyPath: "opacity") // opacity for last quarter ring
        let shadowOpacityAnimation = CABasicAnimation(keyPath: "opacity") // opacity for shadow
        let shadowRotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")

        // Ring Filling Animation
        ringFillAnimation.fromValue = ring2CurrentFill
        ring2TargetFill = percent <= 1 ? (percent-0.75)*4 : 1
        if ring2TargetFill < 0 { ring2TargetFill = 0 }
        ringFillAnimation.toValue = ring2TargetFill
        ringFillAnimation.duration = timings.time2
        ringFillAnimation.fillMode = .both
        ringFillAnimation.isRemovedOnCompletion = false

        // Last quarter of the ring Opacity Animation
        ringOpacityAnimation.duration = 0.01
        ringOpacityAnimation.fillMode = .both
        ringOpacityAnimation.isRemovedOnCompletion = false

        // Shadow Opacity Animation
        shadowOpacityAnimation.duration = timings.time2
        shadowOpacityAnimation.fillMode = .both
        shadowOpacityAnimation.isRemovedOnCompletion = false

        // Shadow Rotation Animation
        shadowRotationAnimation.fromValue = currentShadowRotation
        currentShadowRotation = (2*CGFloat.pi)*(percent <= 1 ? percent : 1)
        if currentShadowRotation < 3*CGFloat.pi/2 { currentShadowRotation = 3*CGFloat.pi/2}
        shadowRotationAnimation.toValue = currentShadowRotation
        shadowRotationAnimation.duration = timings.time2
        shadowRotationAnimation.fillMode = .both
        shadowRotationAnimation.isRemovedOnCompletion = false

        // Logic to handle timing offsets for the animations as well as opacity changes
        if (0.75...1).contains(percent) && !(0.75...1).contains(currentFill) {
            if currentFill < 0.75 { // ring 1, ring 2
                ringFillAnimation.beginTime = CACurrentMediaTime() + timings.time1
                shadowRotationAnimation.beginTime = CACurrentMediaTime() + timings.time1

                shadowOpacityAnimation.createAnimation(fromValue: 0, toValue: 1, beginTimeOffset: timings.time1)
                ringOpacityAnimation.createAnimation(fromValue: 0, toValue: 1, beginTimeOffset: timings.time1)

                self.circleContainer.add(shadowOpacityAnimation, forKey: "opacityAnimation")
                self.gradientMaskPart2.add(ringOpacityAnimation, forKey: "opacityAnimation")
            } else { // ring 3, ring 2
                ringFillAnimation.beginTime = CACurrentMediaTime() + timings.time3
                shadowRotationAnimation.beginTime = CACurrentMediaTime() + timings.time3
            }
        } else if currentFill > 1 && percent <= 0.75 { // ring 3, ring 2, ring 1
            ringFillAnimation.beginTime = CACurrentMediaTime() + timings.time3
            shadowRotationAnimation.beginTime = CACurrentMediaTime() + timings.time3

            shadowOpacityAnimation.createAnimation(fromValue: 1, toValue: 0, beginTimeOffset: timings.time3)
            ringOpacityAnimation.createAnimation(fromValue: 1, toValue: 0, beginTimeOffset: timings.time3+timings.time2)

            self.circleContainer.add(shadowOpacityAnimation, forKey: "opacityAnimation")
            self.gradientMaskPart2.add(ringOpacityAnimation, forKey: "opacityAnimation")
        } else if percent <= 0.75 && (0.75...1).contains(currentFill) { // ring 2, ring 1
            shadowOpacityAnimation.createAnimation(fromValue: 1, toValue: 0)
            ringOpacityAnimation.createAnimation(fromValue: 1, toValue: 0, beginTimeOffset: timings.time2)

            self.circleContainer.add(shadowOpacityAnimation, forKey: "opacityAnimation")
            self.gradientMaskPart2.add(ringOpacityAnimation, forKey: "opacityAnimation")
        } else if percent > 1 && currentFill <= 0.75 { // ring 1, ring 2, ring 3
            ringFillAnimation.beginTime = CACurrentMediaTime() + timings.time1
            shadowRotationAnimation.beginTime = CACurrentMediaTime() + timings.time1

            shadowOpacityAnimation.createAnimation(fromValue: 0, toValue: 1, beginTimeOffset: timings.time1)
            ringOpacityAnimation.createAnimation(fromValue: 0, toValue: 1, beginTimeOffset: timings.time1)

            self.circleContainer.add(shadowOpacityAnimation, forKey: "opacityAnimation")
            self.gradientMaskPart2.add(ringOpacityAnimation, forKey: "opacityAnimation")
        }
        // NOTE:  ring 2, ring 3 requires no changes.

        ring2CurrentFill = ring2TargetFill

        // Mandatory animations that complete no matter direction of last quarter of the ring
        self.circleContainer.add(shadowRotationAnimation, forKey: nil)
        self.gradientMaskPart2.add(ringFillAnimation, forKey: "basicAnimation2")

        if percent > currentFill { //going up
            if percent > 1 { rotateRingAnimation()}
        } else {
            if percent <= 0.75 {animateRing()}
        }

    }

    private func rotateRingAnimation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = ring3CurrentRotation
        ring3TargetRotation = 2*CGFloat.pi+((2*(percent-1)*CGFloat.pi))
        if ring3TargetRotation < 2*CGFloat.pi { ring3TargetRotation = 2*CGFloat.pi}
        rotationAnimation.toValue = ring3TargetRotation
        rotationAnimation.duration = timings.time3
        rotationAnimation.fillMode = CAMediaTimingFillMode.both
        rotationAnimation.isRemovedOnCompletion = false

        if currentFill >= 1 {
            rotationAnimation.beginTime = CACurrentMediaTime()
        } else if (0.75...1).contains(currentFill) {
            rotationAnimation.beginTime = CACurrentMediaTime() + timings.time2
        } else {
            rotationAnimation.beginTime = CACurrentMediaTime() + timings.time1 + timings.time2
        }

        if percent < currentFill && percent <= 1 { ringEndAnimation()}

        ring3CurrentRotation = ring3TargetRotation

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

private extension CABasicAnimation {

    func createAnimation(fromValue: Any?, toValue: Any?, beginTimeOffset: CFTimeInterval = 0) {
        self.fromValue = fromValue
        self.toValue = toValue
        self.beginTime = CACurrentMediaTime() + beginTimeOffset
    }
}
