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
    private var currentRotation = 3*CGFloat.pi/2 // rotation of 270 degrees for shadow circle
    private var percent: CGFloat = 0.01
    private var imageView = UIImageView()
    private var circleContainer = CALayer()
    private var circle = CAShapeLayer()
    private var timings = Timings()

    private var ring1CurrentFill = CGFloat()
    private var ring1TartgetFill = CGFloat()
    private var ring2CurrentFill = CGFloat()
    private var ring2TartgetFill = CGFloat()
    private var ring3CurrentFill = CGFloat()
    private var ring3TartgetFill = CGFloat()

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

    private func calculateTiming() {

        timings.totalDuration = 2
        timings.time1 = 0
        timings.time2 = 0
        timings.time3 = 0
        let oldProgress = Double(currentFill)
        let newProgress = Double(percent)
        let delta = abs(Double(newProgress - oldProgress))

        if oldProgress <= 0.75 && newProgress < 0.75 { // do we need less than or equal to?
            timings.time1 = 1
        } else if oldProgress <= 0.75 && newProgress <= 1 {
            timings.time1 = (0.75-oldProgress)/delta
            timings.time2 = ((newProgress)-0.75)/delta
        } else if oldProgress < 0.75 && newProgress > 1 {
            timings.time1 = (0.75-oldProgress)/delta
            timings.time2 = 0.25/delta
            timings.time3 = (newProgress-1)/delta
        } else if (0.75...1).contains(oldProgress) && (0.75...1).contains(newProgress) {
            timings.time2 = 1
        } else if (0.75...1).contains(oldProgress) && newProgress < 0.75 {
            timings.time1 = (0.75-newProgress)/delta
            timings.time2 = (oldProgress-0.75)/delta
        } else if (0.75...1).contains(oldProgress) && newProgress > 1 {
            timings.time2 = (1-oldProgress)/delta
            timings.time3 = (newProgress-1)/delta
        } else if oldProgress >= 1 && newProgress >= 1 {
            timings.time3 = 1
        } else if oldProgress >= 1 && (0.75...1).contains(newProgress) {
            timings.time2 = (1-newProgress)/delta
            timings.time3 = (oldProgress-1)/delta
        } else if oldProgress >= 1 && newProgress < 0.75 {
            timings.time1 = (0.75-newProgress)/delta
            timings.time2 = 0.25/delta
            timings.time3 = (oldProgress-1)/delta
        }

        timings.time1 *= timings.totalDuration
        timings.time2 *= timings.totalDuration
        timings.time3 *= timings.totalDuration

        print("time 1: \(timings.time1). time2: \(timings.time2). time 3: \(timings.time3)")
//        currentFill = percent // remove me later
//        animateRing()

        if currentFill <= 0.75 {
            animateRing()
        } else {
            ringEndAnimation()
        }
    }

    private func animateRing() {

        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.fromValue = ring1CurrentFill
        ring1TartgetFill = percent > 0.75 ? 0.75 : percent
        basicAnimation.toValue = ring1TartgetFill
        ring1CurrentFill = ring1TartgetFill
//        currentFill = percent
        basicAnimation.fillMode = .both
        basicAnimation.isRemovedOnCompletion = false
        basicAnimation.duration = Double(timings.time1)
//        basicAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)

        if (currentFill > 0.75) {
            basicAnimation.beginTime = CACurrentMediaTime() + timings.time2
        } else {
            basicAnimation.beginTime = CACurrentMediaTime()
        }

        flatColorLayer.add(basicAnimation, forKey: "basicAnimation")
        gradientMaskPart1.add(basicAnimation, forKey: "basicAnimation")

        let needsMultipleAnimations = percent <= 0.75 ? false : true

        if needsMultipleAnimations {ringEndAnimation()} else {
            currentFill = percent
        }

    }

    private func ringEndAnimation() {

//        let timingFunction: CAMediaTimingFunction? = CAMediaTimingFunction(name: .easeOut)

        let basicAnimation2 = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation2.fromValue = ring2CurrentFill
        ring2TartgetFill = percent <= 1 ? (percent-0.75)*4 : 1
        if ring2TartgetFill < 0 { ring2TartgetFill = 0 }
        basicAnimation2.toValue = ring2TartgetFill

        let shadowOpacityAnimation = CABasicAnimation(keyPath: "opacity") // opacity for shadow
        shadowOpacityAnimation.duration = timings.time2
        shadowOpacityAnimation.fillMode = .forwards
        shadowOpacityAnimation.isRemovedOnCompletion = false

        let ringOpacityAnimation = CABasicAnimation(keyPath: "opacity") // opacity for last quarter ring
        ringOpacityAnimation.duration = 0.01
        ringOpacityAnimation.fillMode = .both
        ringOpacityAnimation.isRemovedOnCompletion = false

        if ring2CurrentFill == 0 && ring2TartgetFill > 0 { // show
            shadowOpacityAnimation.fromValue = 0
            shadowOpacityAnimation.toValue = 1
            shadowOpacityAnimation.beginTime = CACurrentMediaTime() + timings.time1

            ringOpacityAnimation.fromValue = 0
            ringOpacityAnimation.toValue = 1
            ringOpacityAnimation.beginTime = CACurrentMediaTime() + timings.time1
            basicAnimation2.beginTime = CACurrentMediaTime() + timings.time1
            self.circleContainer.add(shadowOpacityAnimation, forKey: "opacityAnimation")
            self.gradientMaskPart2.add(ringOpacityAnimation, forKey: "opacityAnimation")
        } else if ring2CurrentFill > 0 && ring2TartgetFill == 0 { // hide
            shadowOpacityAnimation.fromValue = 1
            shadowOpacityAnimation.toValue = 0
            shadowOpacityAnimation.beginTime = CACurrentMediaTime()

            basicAnimation2.beginTime = CACurrentMediaTime()

            ringOpacityAnimation.fromValue = 1
            ringOpacityAnimation.toValue = 0
            ringOpacityAnimation.beginTime = CACurrentMediaTime() + timings.time2
            self.circleContainer.add(shadowOpacityAnimation, forKey: "opacityAnimation")
            self.gradientMaskPart2.add(ringOpacityAnimation, forKey: "opacityAnimation")
        } else if ring2CurrentFill > 0 && ring2TartgetFill > 0 { // no change

        }



        ring2CurrentFill = ring2TartgetFill


        basicAnimation2.duration = timings.time2
        basicAnimation2.fillMode = .both
        basicAnimation2.isRemovedOnCompletion = false
//        basicAnimation2.timingFunction = timingFunction



        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = self.currentRotation
        rotationAnimation.toValue = (2*CGFloat.pi)*(percent <= 1 ? percent : 1)
        self.currentRotation = (2*CGFloat.pi)*(percent <= 1 ? percent : 1)
        rotationAnimation.beginTime = CACurrentMediaTime() + timings.time1
        rotationAnimation.duration = timings.time2
        rotationAnimation.fillMode = CAMediaTimingFillMode.forwards
        rotationAnimation.isRemovedOnCompletion = false
//        rotationAnimation.timingFunction = timingFunction


        self.circleContainer.add(rotationAnimation, forKey: nil)
        self.gradientMaskPart2.add(basicAnimation2, forKey: "basicAnimation2")

        if percent > currentFill { //going up
            let needsMultipleAnimations = percent <= 1 ? false : true

            if needsMultipleAnimations { rotateRingAnimation()} else {
                currentFill = percent
            }
        } else {
            let needsMultipleAnimations = percent <= 0.75 ? true : false

            if needsMultipleAnimations {
                animateRing()

            } else {
                currentFill = percent
            }
        }

    }

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
