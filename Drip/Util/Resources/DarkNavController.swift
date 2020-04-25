import UIKit

final class DarkNavController: UINavigationController {
    
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Find size for blur effect.
        let bounds = navigationBar.bounds.insetBy(dx: 0, dy: -(getStatusBarHeight())).offsetBy(dx: 0, dy: -(getStatusBarHeight()))
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        visualEffectView.frame = navigationBar.bounds.insetBy(dx: 0, dy: -(getStatusBarHeight())).offsetBy(dx: 0, dy: -(getStatusBarHeight()))
    }
    
    private func getStatusBarHeight() -> CGFloat {
        return navigationBar.frame.height
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
