import UIKit

final class TodayView: UIViewController, TodayViewProtocol, PersistentDataViewProtocol {
    var presenter: TodayPresenterProtocol!
    var coreDataController: CoreDataControllerProtocol!
    var userDefaultsController: UserDefaultsControllerProtocol!
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
    @IBOutlet weak var remainingView: UIView!
    @IBOutlet weak var goalView: UIView!
    @IBOutlet weak var remainingLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var addDrinkBtn: UIButton!
    @IBOutlet weak var dottedView: UIView!
    @IBOutlet weak var greetingLabel: UILabel!
    private var displayLink: CADisplayLink?
    private var animationStartDate: Date?
    private var startValue: Double = 0
    private var endValue: Double = 0

    lazy var drinksLauncher = DrinksLauncher(userDefaults: userDefaultsController, isOnboarding: false)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .black
        ringView.backgroundColor = .clear
        presenter.onViewDidLoad()
        setupInfoViews()
        setNavigationTitle()
        progressLabel.font = UIFont.SFProRounded(ofSize: 32, fontWeight: .regular)
        drinksLauncher.delegate = self

        print(userDefaultsController.favBeverage1)
        print(userDefaultsController.favBeverage2)
        print(userDefaultsController.favBeverage3)
        print(userDefaultsController.favBeverage4)
    }

    override func viewDidAppear(_ animated: Bool) {
        presenter.onViewDidAppear()
    }

    override func viewWillAppear(_ animated: Bool) {
        presenter.onViewWillAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        drinksLauncher.removeFromWindow()
        presenter.onViewWillDisappear()
        super.viewWillDisappear(animated)
    }

    func setNavigationTitle() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        let result = formatter.string(from: date)
        navigationItem.title = result
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

    func updateGreetingLabel(text: String) {
        greetingLabel.text = text
    }

    func setupInfoViews() {
        remainingView.layer.cornerRadius = 10
        remainingView.backgroundColor = .clear
        goalView.layer.cornerRadius = 10
        goalView.backgroundColor = .clear
        addDrinkBtn.layer.cornerRadius = 10
        addDrinkBtn.backgroundColor = .infoPanelBG

        remainingLabel.font = UIFont.SFProRounded(ofSize: 28, fontWeight: .medium)
        remainingLabel.textColor = .dripMerged
        remainingLabel.adjustsFontSizeToFitWidth = true // include for iphone se first gen

        goalLabel.font = UIFont.SFProRounded(ofSize: 28, fontWeight: .medium)
        goalLabel.textColor = .dripMerged
        goalLabel.adjustsFontSizeToFitWidth = true // include for iphone se first gen

        addDrinkBtn.setTitleColor(.whiteText, for: .normal)

        dottedView.addVerticalDottedLine()
        dottedView.backgroundColor = .clear

        let goalTap = UITapGestureRecognizer(target: self, action: #selector(self.goalViewTapped(_:)))
        goalView.addGestureRecognizer(goalTap)

    }

    func setupRingView(startColor: UIColor, endColor: UIColor, ringWidth: CGFloat) {
        ringView.setupGradientRingView(progress: 0,
                                            firstColour: UIColor.dripPrimary,
                                            secondColour: UIColor.dripSecondary,
                                            shadowColour: UIColor.dripShadow,
                                            lineWidth: ringWidth,
                                            ringImage: UIImage(named: "dripIcon"))
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

    func setOverviewTitles(remainingText: String, goalText: String) {
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

    @IBAction func addDrinkBtnTapped(_ sender: Any) {
        drinksLauncher.showDrinks()
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

extension TodayView: DrinksLauncherDelegate {
    func didAddDrink(beverage: Beverage, volume: Double) {
        presenter.addDrinkTapped(beverage: beverage, volume: volume)
    }
}
