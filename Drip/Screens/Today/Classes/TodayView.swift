import UIKit

final class TodayView: UIViewController, TodayViewProtocol {
    var presenter: TodayPresenterProtocol!
    @IBOutlet weak var ringView: ProgressRingView!
    @IBOutlet weak var dateLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .black
        presenter.onViewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(action))

        dateLabel.textColor = .white

        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        let result = formatter.string(from: date)
        dateLabel.text = result
    }

    override func viewDidAppear(_ animated: Bool) {
        presenter.onViewDidAppear()
    }

    func presentView(_ view: UIViewController) {
        present(view, animated: true)
    }

    func showView(_ view: UIViewController) {
        show(view, sender: self)
    }

    func updateTitle(title: String) {
        self.title = title
    }

    func setupRingView(startColor: UIColor, endColor: UIColor, ringWidth: CGFloat) {
        ringView.setupGradientRingView(progress: 0,
                                             firstColour: startColor,
                                             secondColour: endColor,
                                             shadowColour: .darkGray,
                                             lineWidth: ringWidth)
    }

    func setRingProgress(progress: Double) {
        ringView.setProgress(CGFloat(progress))
    }

    @objc func action(sender: UIBarButtonItem) {
        // Function body goes here
        print("testy123")
    }

}
