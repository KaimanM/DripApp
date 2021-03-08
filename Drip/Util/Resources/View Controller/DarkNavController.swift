import UIKit

final class DarkNavController: UINavigationController {

    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    var lineView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Find size for blur effect.
        let bounds = navigationBar.bounds.insetBy(dx: 0,
                                                  dy: -(SBHeight())).offsetBy(dx: 0, dy: -(SBHeight()))
        // Create blur effect.

        visualEffectView.frame = bounds
        // Set navigation bar up.
        navigationBar.isTranslucent = true
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.addSubview(visualEffectView)
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        visualEffectView.layer.zPosition = -1
        visualEffectView.isUserInteractionEnabled = false

        lineView.backgroundColor = UIColor.darkGray
        lineView.layer.opacity = 1
        lineView.frame = CGRect(x: 0, y: SBHeight(), width:navigationBar.frame.width, height: 0.5)
        navigationBar.addSubview(lineView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        visualEffectView.frame = navigationBar.bounds.insetBy(dx: 0,
                                                              dy: -(SBHeight())).offsetBy(dx: 0,
                                                                                          dy: -(SBHeight()))
        lineView.frame = CGRect(x: 0, y: SBHeight(), width:navigationBar.frame.width, height: 0.5)

    }

    // Status bar height
    private func SBHeight() -> CGFloat {
        return navigationBar.frame.height
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
