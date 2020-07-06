import UIKit

class GradientView: UIView {

    private let gradientLayer = CAGradientLayer()
    private var baseWidth = CGFloat()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.addSublayer(gradientLayer)
        backgroundColor = UIColor.clear
        layer.anchorPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.colors = [UIColor.dripSecondary.cgColor, UIColor.dripPrimary.cgColor]
        gradientLayer.frame = bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.cornerRadius = bounds.height/2
        gradientLayer.anchorPoint = CGPoint(x: 0, y: 0.5)
    }

    func setProgress(progress: CGFloat) {
        if (baseWidth == 0) {
            baseWidth = gradientLayer.bounds.width
        }
        print(baseWidth)
        let basicAnimation = CABasicAnimation(keyPath: "bounds.size.width")
        basicAnimation.fromValue = baseWidth
        basicAnimation.toValue = gradientLayer.bounds.width*progress
        basicAnimation.duration = 2.25
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        basicAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        gradientLayer.add(basicAnimation, forKey: "basicAnimation")
        baseWidth = gradientLayer.bounds.width*progress
    }
}
