import UIKit

final class TodayView: UIViewController, TodayViewProtocol {
    var presenter: TodayPresenterProtocol!
    @IBOutlet weak var ringView: ProgressRingView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var todayVolumeLabel: UILabel!
    @IBOutlet weak var todayGradientBarView: GradientBarView!
    @IBOutlet weak var thisMorningVolumeLabel: UILabel!
    @IBOutlet weak var thisMorningGradientBarView: GradientBarView!

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

        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        let result = formatter.string(from: date)
        navigationItem.title = result
        progressLabel.font = UIFont.SFProRounded(ofSize: 32, fontWeight: .regular)
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

        var randomDouble = Double.random(in: 0...1)

        todayVolumeLabel.text = "\(Int(round(randomDouble*2750)))/2750ml"
        todayVolumeLabel.font = UIFont.SFProRounded(ofSize: 28, fontWeight: .medium)
        todayVolumeLabel.textColor = UIColor.hexStringToUIColor(hex: "38E3C5")
        todayGradientBarView.setProgress(progress: CGFloat(randomDouble))

        randomDouble = Double.random(in: 0...1)
        thisMorningVolumeLabel.text = "\(Int(round(randomDouble*700)))/700ml"
        thisMorningVolumeLabel.font = UIFont.SFProRounded(ofSize: 28, fontWeight: .medium)
        thisMorningVolumeLabel.textColor = UIColor.hexStringToUIColor(hex: "38E3C5")
        thisMorningGradientBarView.setProgress(progress: CGFloat(randomDouble))
    }

    @objc func action(sender: UIBarButtonItem) {
        // Function body goes here
        print("testy123")
    }

}
