import UIKit

final class TodayView: UIViewController, TodayViewProtocol {
    var presenter: TodayPresenterProtocol!
    @IBOutlet weak var ringView: ProgressRingView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var todayVolumeLabel: UILabel!
    @IBOutlet weak var todayGradientBarView: GradientBarView!
    @IBOutlet weak var thisMorningVolumeLabel: UILabel!
    @IBOutlet weak var thisMorningGradientBarView: GradientBarView!
    @IBOutlet weak var drinkButton1: UIButton!
    @IBOutlet weak var drinkButton2: UIButton!
    @IBOutlet weak var drinkButton3: UIButton!
    @IBOutlet weak var drinkButton4: UIButton!
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

        updateButtonImages()
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

    func updateButtonImages() {
        drinkButton1.setImage(UIImage(named: "waterbottle.svg"), for: .normal)
        drinkButton2.setImage(UIImage(named: "coffee.svg"), for: .normal)
        drinkButton3.setImage(UIImage(named: "cola.svg"), for: .normal)
        drinkButton4.setImage(UIImage(named: "add.svg"), for: .normal)

    }

    func setupRingView(startColor: UIColor, endColor: UIColor, ringWidth: CGFloat) {
        ringView.setupGradientRingView(progress: 0,
                                            firstColour: UIColor.dripPrimary,
                                            secondColour: UIColor.dripSecondary,
                                            shadowColour: UIColor.dripPrimary.withAlphaComponent(0.15),
                                            lineWidth: ringWidth)
    }

    func setRingProgress(progress: Double) {
        ringView.setProgress(CGFloat(progress))
//        progressLabel.text = "\(Int(round(progress*100)))%"
        animateLabel(endValue: progress*100, animationDuration: 2)

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
        setRingProgress(progress: Double.random(in: 0...1))
        print("drink button 1 tapped")
    }

}
