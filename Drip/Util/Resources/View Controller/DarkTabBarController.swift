import UIKit

class DarkTabBarController: UITabBarController {

    var lineView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.isTranslucent = true
        tabBar.backgroundImage = UIImage()
//        tabBar.shadowImage = UIImage() // add this if you want remove tabBar separator
        tabBar.barTintColor = .clear
        tabBar.backgroundColor = .black // here is your tabBar color
        tabBar.layer.backgroundColor = UIColor.clear.cgColor
        tabBar.tintColor = .cyan

        let blurEffect = UIBlurEffect(style: .dark) // here you can change blur style
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.view.bounds
        blurView.autoresizingMask = .flexibleWidth
        tabBar.insertSubview(blurView, at: 0)

        lineView.backgroundColor = UIColor.white
        lineView.layer.opacity = 0.25
        lineView.frame = CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 0.5)
        tabBar.addSubview(lineView)
    }

    override func viewDidLayoutSubviews() {
        lineView.frame = CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 0.5)
    }

}
