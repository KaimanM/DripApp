import UIKit

class GradientBarView: UIView {

    private let gradientLayer = CAGradientLayer()
    private let shadowLayer = CAShapeLayer()
    private var baseWidth = CGFloat()
    private var percent = CGFloat()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.addSublayer(shadowLayer)
        layer.addSublayer(gradientLayer)
        backgroundColor = UIColor.clear
        gradientLayer.colors = [UIColor.dripSecondary.cgColor, UIColor.dripPrimary.cgColor]
        gradientLayer.frame = bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.cornerRadius = bounds.height/2
        gradientLayer.anchorPoint = CGPoint(x: 0, y: 0)

        shadowLayer.backgroundColor = UIColor.dripShadow.cgColor
        shadowLayer.frame = bounds
        shadowLayer.cornerRadius = bounds.height/2
        shadowLayer.anchorPoint = CGPoint(x: 0, y: 0)
    }

    func setProgress(progress: CGFloat) {
        let correctedProgress = progress > 1 ? 1 : progress
        self.percent = correctedProgress
        animateBarWithDuration(2)
    }

    private func animateBarWithDuration(_ duration: CFTimeInterval) {
        if (baseWidth < 30) {
            baseWidth = 30
        }
        let basicAnimation = CABasicAnimation(keyPath: "bounds.size.width")
        basicAnimation.fromValue = baseWidth
        // this stops issue of miniumum being less than a perfect circle
        let correctedValue = gradientLayer.bounds.width*percent < 30 ? 30 : gradientLayer.bounds.width*percent
        basicAnimation.toValue = correctedValue
        basicAnimation.duration = duration
        basicAnimation.fillMode = .both
        basicAnimation.isRemovedOnCompletion = false
        baseWidth = gradientLayer.bounds.width*percent
        gradientLayer.add(basicAnimation, forKey: "basicAnimation")
    }

    override func layoutSubviews() {
        gradientLayer.frame = bounds
        shadowLayer.frame = bounds
//        animateBar()
        animateBarWithDuration(0.1)
    }
}
