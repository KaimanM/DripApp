import UIKit
import FSCalendar

final class HistoryView: UIViewController, HistoryViewProtocol {

    var presenter: HistoryPresenterProtocol!
    @IBOutlet var calendar: FSCalendar!

    override func viewDidLoad() {
        presenter.onViewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.prefersLargeTitles = true
        calendar.dataSource = self
        calendar.delegate = self
        calendar.register(CustomFSCell.self, forCellReuseIdentifier: "cell")
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

    func presentView(_ view: UIViewController) {
        present(view, animated: true)
    }

    func showView(_ view: UIViewController) {
        show(view, sender: self)
    }

    func updateTitle(title: String) {
        self.title = title
    }

}

extension HistoryView: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

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
            cell.ringView.setProgress(0)
        }
        return cell
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("selected: \(date)")
    }

}
