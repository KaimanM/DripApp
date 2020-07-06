import UIKit

final class TodayView: UIViewController, TodayViewProtocol {
    var presenter: TodayPresenterProtocol!
    @IBOutlet weak var ringView: ProgressRingView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var todayVolumeLabel: UILabel!
    @IBOutlet weak var todayGradientView: GradientView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .black
        ringView.backgroundColor = .clear
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
        progressLabel.font = UIFont.SFProRounded(ofSize: 32)
        todayVolumeLabel.font = UIFont.SFProRounded(ofSize: 28)
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
                                            firstColour: UIColor.dripPrimary,
                                            secondColour: UIColor.dripSecondary,
                                            shadowColour: .darkGray,
                                            lineWidth: ringWidth)
    }

    func setRingProgress(progress: Double) {
        ringView.setProgress(CGFloat(progress))
        progressLabel.text = "\(Int(round(progress*100)))%"
        todayGradientView.setProgress(progress: CGFloat(Double.random(in: 0...1)))
    }

    @objc func action(sender: UIBarButtonItem) {
        // Function body goes here
        print("testy123")
    }

}
