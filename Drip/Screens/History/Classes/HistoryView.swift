import UIKit
import FSCalendar
// TODO : Update SPM to use scheduled release after next release. 2.6.2 does need include required fix.

final class HistoryView: UIViewController, HistoryViewProtocol, PersistentDataViewProtocol {

    var presenter: HistoryPresenterProtocol!
    var coreDataController: CoreDataControllerProtocol!
    var userDefaultsController: UserDefaultsControllerProtocol!
    @IBOutlet var calendar: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoPanelView: UIView!
    @IBOutlet weak var ringView: ProgressRingView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var addDrinkButton: UIButton!

    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar,
                                                action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
    }()

    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()

    override func viewDidLoad() {
        presenter.onViewDidLoad()
        calendar.dataSource = self
        calendar.delegate = self
        calendar.register(CustomFSCell.self, forCellReuseIdentifier: "cell")

        setupAddDrinkBtn()
        drinksLauncher.delegate = self

        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        tableView.separatorColor = .clear

        self.view.addGestureRecognizer(self.scopeGesture)
        self.scrollView.panGestureRecognizer.require(toFail: self.scopeGesture)
    }

    // Usually I would do data loading here, but this is calling before the viewwilldisappear of other views.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // load data here
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.onViewDidAppear()
        self.tableView.reloadData()
        self.calendar.reloadData()
        self.viewWillLayoutSubviews() // readjusts height of tableview
    }

    override func viewWillDisappear(_ animated: Bool) {
        drinksLauncher.removeFromWindow()
        presenter.onViewWillDisappear()
        super.viewWillDisappear(animated)
    }

    func setupInfoPanel() {
        infoPanelView.layer.cornerRadius = 10
        infoPanelView.backgroundColor = .infoPanelBG
        ringView.setupGradientRingView(progress: 0,
                                       firstColour: .dripPrimary,
                                       secondColour: .dripSecondary,
                                       shadowColour: .dripShadow,
                                       lineWidth: 20,
                                       ringImage: UIImage(named: "dripIconBold"))
        ringView.backgroundColor = .clear
        dayLabel.font = UIFont.SFProRounded(ofSize: 24, fontWeight: .regular)
        dayLabel.textColor = .white
        subtitleLabel.textColor = .white
        subtitleLabel.font = UIFont.SFProRounded(ofSize: 16, fontWeight: .regular)
        volumeLabel.font = UIFont.SFProRounded(ofSize: 30, fontWeight: .medium)
        volumeLabel.textColor = .dripMerged
    }

    func setupCalendar() {
        calendar.appearance.todayColor = UIColor(named: "todaysDate")
        calendar.firstWeekday = 2
        calendar.appearance.weekdayTextColor = UIColor(named: "whiteText")
        calendar.appearance.headerTitleColor = UIColor(named: "whiteText")
        calendar.appearance.selectionColor = UIColor.gray
        calendar.appearance.titleDefaultColor = UIColor(named: "whiteText")
        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 12)
        calendar.backgroundColor = .clear
        calendar.scope = .week
    }

    func setupAddDrinkBtn() {
        addDrinkButton.backgroundColor = .infoPanelBG
        addDrinkButton.layer.cornerRadius = 10
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

    func refreshUI() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.calendar.reloadData()
            self.viewWillLayoutSubviews()
        }
    }

    func updateRingView(progress: CGFloat, date: Date, total: Double, goal: Double) {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        dayLabel.text = formatter.string(from: date)

        ringView.setProgress(progress, duration: 2)
        volumeLabel.text = "\(Int(total))/\(Int(goal))ml"
    }

    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tableViewHeightConstraint?.constant = tableView.contentSize.height
    }

    @IBAction func calendarToggleTapped(_ sender: Any) {
        if self.calendar.scope == .month {
            self.calendar.setScope(.week, animated: true)
        } else {
            self.calendar.setScope(.month, animated: true)
        }
    }

    func updateEditButton(title: String) {
        editButton.setTitle(title, for: .normal)
    }

    @IBAction func editToggleTapped(_ sender: Any) {
        presenter.editToggleTapped()
    }

    lazy var drinksLauncher = DrinksLauncher(userDefaults: userDefaultsController, isOnboarding: false)

    @IBAction func addMissingDrinkBtnTapped(_ sender: Any) {
        drinksLauncher.showDrinks()
    }

    let drinkNames = ["Water", "Coffee", "Tea", "Milk", "Orange Juice", "Juicebox",
                      "Cola", "Cocktail", "Punch", "Milkshake", "Energy Drink", "Beer"] // icetea

    let drinkImageNames = ["waterbottle.svg", "coffee.svg", "tea.svg", "milk.svg", "orangejuice.svg",
                            "juicebox.svg", "cola.svg", "cocktail.svg", "punch.svg", "milkshake.svg",
                            "energydrink.svg", "beer.svg"]

}

extension HistoryView: UIGestureRecognizerDelegate {

    // Handles Swipe to open calendar gesture
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = self.scrollView.contentOffset.y <= -self.scrollView.contentInset.top
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)
            switch self.calendar.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
            @unknown default:
                fatalError()
            }
        }
        return shouldBegin
    }

}

extension HistoryView: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    // Populates Calendar Cells
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {

        guard let cell = calendar.dequeueReusableCell(withIdentifier: "cell",
                                                      for: date,
                                                      at: position) as? CustomFSCell else {
            return FSCalendarCell()
        }

        cell.ringView.setProgress(CGFloat(presenter.cellForDate(date: date)), duration: 0)

        return cell
    }

    // Selected Calendar Cell
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }

        presenter.didSelectDate(date: date)
        tableView.reloadData()
    }

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }

    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }

}

extension HistoryView: UITableViewDelegate, UITableViewDataSource, DrinkTableViewCellDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "drinkCell") as? DrinkTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.deleteButton.isHidden = presenter.isHidingEditButton()
        let cellData = presenter.cellForRowAt(row: indexPath.row)
        cell.drinkLabel.text = cellData.name
        cell.volumeLabel.text = cellData.volume
        cell.drinkImageView?.image = UIImage(named: cellData.imageName)?
//            .withTintColor(UIColor.white.withAlphaComponent(0.5))
            .withAlignmentRectInsets(UIEdgeInsets(top: -15,
                                                  left: -15,
                                                  bottom: -15,
                                                  right: -15))
        cell.deleteButton.tag = indexPath.row
        cell.timeStampLabel.text = cellData.timeStampTitle

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func didTapButton(_ sender: UIButton) {
        presenter.didTapDeleteButton(row: sender.tag)
    }

}

extension HistoryView: DrinksLauncherDelegate {
    func didAddDrink(beverage: Beverage, volume: Double) {
        presenter.addDrinkTapped(beverage: beverage, volume: volume)
    }
}
