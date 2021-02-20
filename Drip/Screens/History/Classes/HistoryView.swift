import UIKit
import FSCalendar

final class HistoryView: UIViewController, HistoryViewProtocol {

    var presenter: HistoryPresenterProtocol!
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
    let drinkNames = ["Water", "Coffee", "Soda"]
    let drinkImageNames = ["waterbottle.svg", "coffee.svg", "cola.svg"]

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

        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        tableView.separatorColor = .clear

        self.view.addGestureRecognizer(self.scopeGesture)
        self.scrollView.panGestureRecognizer.require(toFail: self.scopeGesture)
        setupInfoPanel()
    }

    override func viewDidAppear(_ animated: Bool) {
        presenter.onViewDidAppear()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidLoad()
    }

    func setupInfoPanel() {
        infoPanelView.layer.cornerRadius = 10
        infoPanelView.backgroundColor = .infoPanelBG
        ringView.setupGradientRingView(progress: 0,
                                       firstColour: .dripPrimary,
                                       secondColour: .dripSecondary,
                                       shadowColour: .dripShadow,
                                       lineWidth: 20,
                                       ringImage: UIImage(named: "icon-clear-noshadow"))
        ringView.backgroundColor = .clear
        dayLabel.font = UIFont.SFProRounded(ofSize: 24, fontWeight: .regular)
        dayLabel.textColor = .white
        subtitleLabel.textColor = .white
        subtitleLabel.font = UIFont.SFProRounded(ofSize: 16, fontWeight: .regular)
        volumeLabel.font = UIFont.SFProRounded(ofSize: 30, fontWeight: .medium)
        volumeLabel.textColor = .dripMerged
        calendar.scope = .week
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

    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
//        print("tableview height at willlayoutsubviews: \(tableView.contentSize.height)")
        self.tableViewHeightConstraint?.constant = tableView.contentSize.height
    }

    @IBAction func calendarToggleTapped(_ sender: Any) {
        if self.calendar.scope == .month {
            self.calendar.setScope(.week, animated: true)
        } else {
            self.calendar.setScope(.month, animated: true)
        }
    }

}

extension HistoryView: UIGestureRecognizerDelegate {

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

    // populates cell
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
//        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position) as! CustomFSCell

        guard let cell = calendar.dequeueReusableCell(withIdentifier: "cell",
                                                      for: date,
                                                      at: position) as? CustomFSCell else {
            return FSCalendarCell()
        }

        if Calendar.current.isDate(date, inSameDayAs: Date()) {
            cell.ringView.setProgress(0.8)
        } else {
            let randomDouble = Double.random(in: 0...1) // remove me, placeholder

            cell.ringView.setProgress(CGFloat(randomDouble))
        }
        return cell
    }

    // did select
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        dayLabel.text = formatter.string(from: date)

        let randomDouble = Double.random(in: 0...1) // remove me, placeholder
        ringView.setProgress(CGFloat(randomDouble))
        volumeLabel.text = "\(Int(randomDouble*2750))/2750ml"
        tableView.reloadData()
//        self.tableViewHeightConstraint?.constant = 1000 // do we need this somewhere to fix bug
//        self.view.layoutIfNeeded()

//        print("tableview height: \(tableView.contentSize.height)")

    }

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }

    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }

}

extension HistoryView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int.random(in: 0...5)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

//        let cell = self.tableView.dequeueReusableCell(withIdentifier: "drinkCell") as! DrinkTableViewCell

        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "drinkCell") as? DrinkTableViewCell else {
            return UITableViewCell()
        }

        let randomInt = Int.random(in: 0...2)
        cell.drinkLabel.text = drinkNames[randomInt]
        let randomInt2 = Int.random(in: 100...500)
        cell.volumeLabel.text = "\(randomInt2)ml"
        cell.drinkImageView?.image = UIImage(named: drinkImageNames[randomInt])?
            .withTintColor(UIColor.white.withAlphaComponent(0.5))
            .withAlignmentRectInsets(UIEdgeInsets(top: -15,
                                                  left: -15,
                                                  bottom: -15,
                                                  right: -15))

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}
