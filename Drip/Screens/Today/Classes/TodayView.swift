import UIKit

final class TodayView: UIViewController, TodayViewProtocol {
    var presenter: TodayPresenterProtocol!
    @IBOutlet weak var ringView: ProgressRingView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var todayVolumeLabel: UILabel!
    @IBOutlet weak var todayGradientBarView: GradientBarView!
    @IBOutlet weak var thisMorningVolumeLabel: UILabel!
    @IBOutlet weak var thisMorningGradientBarView: GradientBarView!
    @IBOutlet weak var thisAfternoonVolumeLabel: UILabel!
    @IBOutlet weak var thisAfternoonGradientBarView: GradientBarView!
    @IBOutlet weak var thisEveningVolumeLabel: UILabel!
    @IBOutlet weak var thisEveningGradientBarView: GradientBarView!
    @IBOutlet weak var drinkButton1: UIButton!
    @IBOutlet weak var drinkButton2: UIButton!
    @IBOutlet weak var drinkButton3: UIButton!
    @IBOutlet weak var drinkButton4: UIButton!
    @IBOutlet weak var button1Subtitle: UILabel!
    @IBOutlet weak var button2Subtitle: UILabel!
    @IBOutlet weak var button3Subtitle: UILabel!
    @IBOutlet weak var button4Subtitle: UILabel!
    private var displayLink: CADisplayLink?
    private var animationStartDate: Date?
    private var startValue: Double = 0
    private var endValue: Double = 0

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

    func updateButtonImages(image1Name: String, image2Name: String, image3Name: String, image4Name: String) {
        drinkButton1.setImage(UIImage(named: image1Name), for: .normal)
        drinkButton2.setImage(UIImage(named: image2Name), for: .normal)
        drinkButton3.setImage(UIImage(named: image3Name), for: .normal)
        drinkButton4.setImage(UIImage(named: image4Name), for: .normal)
        drinkButton4.imageEdgeInsets = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
    }

    func updateButtonSubtitles(subtitle1: String, subtitle2: String, subtitle3: String, subtitle4: String) {
        button1Subtitle.text = subtitle1
        button2Subtitle.text = subtitle2
        button3Subtitle.text = subtitle3
        button4Subtitle.text = subtitle4
    }

    func setupRingView(startColor: UIColor, endColor: UIColor, ringWidth: CGFloat) {
        ringView.setupGradientRingView(progress: 0,
                                            firstColour: UIColor.dripPrimary,
                                            secondColour: UIColor.dripSecondary,
                                            shadowColour: UIColor.dripShadow,
                                            lineWidth: ringWidth)
    }

    func setRingProgress(progress: Double) {
        ringView.setProgress(CGFloat(progress))

        var randomDouble = Double.random(in: 0...1)

        todayVolumeLabel.text = "\(Int(round(randomDouble*2750)))/2750ml"
        todayVolumeLabel.font = UIFont.SFProRounded(ofSize: 28, fontWeight: .medium)
        todayVolumeLabel.textColor = .dripMerged
        todayGradientBarView.setProgress(progress: CGFloat(randomDouble))

        randomDouble = Double.random(in: 0...1)
        thisMorningVolumeLabel.text = "\(Int(round(randomDouble*700)))/700ml"
        thisMorningVolumeLabel.font = UIFont.SFProRounded(ofSize: 28, fontWeight: .medium)
        thisMorningVolumeLabel.textColor = .dripMerged
        thisMorningGradientBarView.setProgress(progress: CGFloat(randomDouble))

        randomDouble = Double.random(in: 0...1)
        thisAfternoonVolumeLabel.text = "\(Int(round(randomDouble*700)))/700ml"
        thisAfternoonVolumeLabel.font = UIFont.SFProRounded(ofSize: 28, fontWeight: .medium)
        thisAfternoonVolumeLabel.textColor = .dripMerged
        thisAfternoonGradientBarView.setProgress(progress: CGFloat(randomDouble))

        randomDouble = Double.random(in: 0...1)
        thisEveningVolumeLabel.text = "\(Int(round(randomDouble*700)))/700ml"
        thisEveningVolumeLabel.font = UIFont.SFProRounded(ofSize: 28, fontWeight: .medium)
        thisEveningVolumeLabel.textColor = .dripMerged
        thisEveningGradientBarView.setProgress(progress: CGFloat(randomDouble))

    }

    func animateLabel(endValue: Double, animationDuration: Double) {
        animationStartDate = Date()
        self.endValue = endValue
        displayLink = CADisplayLink(target: self, selector: #selector(handleUpdate))
        displayLink?.add(to: .main, forMode: .default)
    }

    @objc func handleUpdate() {
        let animationDuration: Double = 2
        let now = Date()
        let elapsedTime = now.timeIntervalSince(animationStartDate!)

        if elapsedTime > animationDuration {
            self.progressLabel.text = "\(Int(endValue))%"
            displayLink?.invalidate()
            self.startValue = endValue
        } else {
            let percentage = elapsedTime / animationDuration
            let value = startValue + percentage * (endValue - startValue)
            self.progressLabel.text = "\(Int(value))%"
        }
    }

    @objc func action(sender: UIBarButtonItem) {
        // Function body goes here
        print("testy123")
    }
    @IBAction func drinkButton1Tapped(_ sender: Any) {
        presenter.onDrinkButton1Tapped()
    }

}
