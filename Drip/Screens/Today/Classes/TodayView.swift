import UIKit

final class TodayView: UIViewController, TodayViewProtocol, CoreDataViewProtocol {
    var presenter: TodayPresenterProtocol!
    var coreDataController: CoreDataControllerProtocol!
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
    @IBOutlet weak var remainingView: UIView!
    @IBOutlet weak var goalView: UIView!
    @IBOutlet weak var addDrinkView: UIView!
    @IBOutlet weak var remainingLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var addImageView: UIImageView!
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
        setupButtonViews()

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

    override func viewWillAppear(_ animated: Bool) {
        presenter.onViewWillAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        presenter.onViewWillDisappear()
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
//        drinkButton1.setImage(UIImage(named: image1Name), for: .normal)
//        drinkButton2.setImage(UIImage(named: image2Name), for: .normal)
//        drinkButton3.setImage(UIImage(named: image3Name), for: .normal)
//        drinkButton4.setImage(UIImage(named: image4Name), for: .normal)
//        drinkButton4.imageEdgeInsets = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
    }

    func updateButtonSubtitles(subtitle1: String, subtitle2: String, subtitle3: String, subtitle4: String) {
//        button1Subtitle.text = subtitle1
//        button2Subtitle.text = subtitle2
//        button3Subtitle.text = subtitle3
//        button4Subtitle.text = subtitle4
    }

    func setupButtonViews() {
        remainingView.layer.cornerRadius = 10
        remainingView.backgroundColor = .clear
        goalView.layer.cornerRadius = 10
        goalView.backgroundColor = .clear
        addDrinkView.layer.cornerRadius = 10
        addDrinkView.backgroundColor = .infoPanelBG

        remainingLabel.font = UIFont.SFProRounded(ofSize: 28, fontWeight: .medium)
        remainingLabel.textColor = .dripMerged
        remainingLabel.adjustsFontSizeToFitWidth = true // include for iphone se first gen

        goalLabel.font = UIFont.SFProRounded(ofSize: 28, fontWeight: .medium)
        goalLabel.textColor = .dripMerged
        goalLabel.adjustsFontSizeToFitWidth = true // include for iphone se first gen

        addImageView.image = UIImage(named: "add.svg")
        addImageView.tintColor = UIColor.dripMerged

        let addTap = UITapGestureRecognizer(target: self, action: #selector(self.addDrinkTapped(_:)))
        let goalTap = UITapGestureRecognizer(target: self, action: #selector(self.goalViewTapped(_:)))
        goalView.addGestureRecognizer(goalTap)
        addDrinkView.addGestureRecognizer(addTap)

    }

    func setupRingView(startColor: UIColor, endColor: UIColor, ringWidth: CGFloat) {
        ringView.setupGradientRingView(progress: 0,
                                            firstColour: UIColor.dripPrimary,
                                            secondColour: UIColor.dripSecondary,
                                            shadowColour: UIColor.dripShadow,
                                            lineWidth: ringWidth,
                                            ringImage: UIImage(named: "icon-clear-noshadow"))
    }

    func setupGradientBars(dailyGoal: Int, morningGoal: Int, afternoonGoal: Int, eveningGoal: Int) {
        todayVolumeLabel.text = "0/\(dailyGoal)ml"
        todayVolumeLabel.font = UIFont.SFProRounded(ofSize: 28, fontWeight: .medium)
        todayVolumeLabel.textColor = .dripMerged

        thisMorningVolumeLabel.text = "0/\(morningGoal)ml"
        thisMorningVolumeLabel.font = UIFont.SFProRounded(ofSize: 28, fontWeight: .medium)
        thisMorningVolumeLabel.textColor = .dripMerged

        thisAfternoonVolumeLabel.text = "0/\(afternoonGoal)ml"
        thisAfternoonVolumeLabel.font = UIFont.SFProRounded(ofSize: 28, fontWeight: .medium)
        thisAfternoonVolumeLabel.textColor = .dripMerged

        thisEveningVolumeLabel.text = "0/\(eveningGoal)ml"
        thisEveningVolumeLabel.font = UIFont.SFProRounded(ofSize: 28, fontWeight: .medium)
        thisEveningVolumeLabel.textColor = .dripMerged
    }

    func setRingProgress(progress: Double) {
        ringView.setProgress(CGFloat(progress), duration: 2)
    }

    func setTodayGradientBarProgress(total: Double, goal: Double) {
        todayVolumeLabel.text = "\(Int(total))/\(Int(goal))ml"
        todayGradientBarView.setProgress(progress: CGFloat(total/goal))
    }

    func setMorningGradientBarProgress(total: Double, goal: Double) {
        thisMorningVolumeLabel.text = "\(Int(total))/\(Int(goal))ml"
        thisMorningGradientBarView.setProgress(progress: CGFloat(total/goal))
    }

    func setAfternoonGradientBarProgress(total: Double, goal: Double) {
        thisAfternoonVolumeLabel.text = "\(Int(total))/\(Int(goal))ml"
        thisAfternoonGradientBarView.setProgress(progress: CGFloat(total/goal))
    }

    func setEveningGradientBarProgress(total: Double, goal: Double) {
        thisEveningVolumeLabel.text = "\(Int(total))/\(Int(goal))ml"
        thisEveningGradientBarView.setProgress(progress: CGFloat(total/goal))
    }

    func setButtonTitles(remainingText: String, goalText: String) {
        remainingLabel.text = remainingText
        goalLabel.text = goalText
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

    @objc func addDrinkTapped(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        print("did tap")
        presenter.addDrinkTapped()
    }

    @objc func goalViewTapped(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        print("did tap")
        let alertContoller = UIAlertController(title: "Amend Goal",
                                    message: "Enter a new goal volume in ml.", preferredStyle: .alert)
        alertContoller.addTextField()
        alertContoller.textFields![0].keyboardType = UIKeyboardType.numberPad

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned alertContoller] _ in
            if let answer: String = alertContoller.textFields![0].text,
               let answerAsDouble = Double(answer) {
                guard answerAsDouble != 0 else {
                    print("can not be 0")
                    return
                }
                self.presenter.updateGoal(goal: answerAsDouble)
            } else {
                print("invalid")
            }

        }

        alertContoller.addAction(submitAction)

        present(alertContoller, animated: true)
    }

}
