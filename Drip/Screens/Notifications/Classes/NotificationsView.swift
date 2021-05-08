import UIKit

class NotificationsView: UIViewController, NotificationsViewProtocol {
    var presenter: NotificationsPresenterProtocol!

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .black
//        tableView.contentInset.bottom = 5
        tableView.contentInset.top = 5 // Removes padding caused by grouped style
        return tableView
    }()

    let toggle: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = .dripMerged
        return toggle
    }()

    let textField: UITextField = {
        let textField = UITextField()
        textField.text = "8 Daily Reminders"
        textField.textColor = .whiteText
        textField.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.textAlignment = .center
        textField.tintColor = .clear
        return textField
    }()

    let headingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .whiteText
        return label
    }()

    let bodyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.numberOfLines = 0
        return label
    }()

    let childStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()

    let toggleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .whiteText
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.text = "Enable Reminders"
        return label
    }()

    let topContainerView = UIView(), lineView1 = UIView(), lineView2 = UIView(), lineView3 = UIView()

    let picker = UIPickerView()

    let scrollView = UIScrollView()

    let cellId = "cellId"

    var reminderCount = 3

    var tableViewHeight: NSLayoutConstraint?

    override func viewDidLoad() {
        self.navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .black

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NotificationsTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.isScrollEnabled = false

        setupNotificationsView(headingText: "dsfsdf", bodyText: "dfsdf")

//        view?.updateTitle(title: "Notifications")
//        let headingText = "Daily Reminders"
//        let bodyText = """
//            Use this settings page to configure setting up daily reminder notifications.
//
//            We've set you up with three notifications but feel free to customise them to your needs!
//            """
//        view?.setupNotificationsView(headingText: headingText, bodyText: bodyText)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.onViewDidAppear()
    }

    func updateTitle(title: String) {
    }

    func setupNotificationsView(headingText: String, bodyText: String) {
        toggle.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)

        picker.delegate = self
        picker.dataSource = self

        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done,
                                         target: self, action: #selector(doneTapped))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        textField.inputView = picker
        textField.inputAccessoryView = toolBar

        view.addSubview(scrollView)
        scrollView.addSubview(childStackView)

        lineView1.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        lineView2.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        lineView3.backgroundColor = UIColor.white.withAlphaComponent(0.2)

        let subViews = [headingLabel, bodyLabel, lineView1, toggleLabel, toggle, lineView2, textField, lineView3]
        subViews.forEach({topContainerView.addSubview($0)})

        let arrangedSubviews = [topContainerView, tableView]
        arrangedSubviews.forEach({childStackView.addArrangedSubview($0)})

        scrollView.fillSuperView()
        childStackView.fillSuperView()
        childStackView.setEqualWidthTo(scrollView)

        headingLabel.text = headingText
        bodyLabel.text = bodyText
        setupConstraints()
    }

    // swiftlint:disable:next function_body_length
    func setupConstraints() {
        tableViewHeight = NSLayoutConstraint(item: tableView,
                                             attribute: .height,
                                             relatedBy: .equal,
                                             toItem: nil, attribute: .notAnAttribute,
                                             multiplier: 1,
                                             constant: CGFloat(reminderCount*60)+10)
        tableView.addConstraint(tableViewHeight!)

        headingLabel.anchor(top: topContainerView.topAnchor,
                            leading: topContainerView.leadingAnchor,
                            trailing: topContainerView.trailingAnchor,
                            padding: .init(top: 10, left: 20, bottom: 0, right: 20))
        bodyLabel.anchor(top: headingLabel.bottomAnchor,
                            leading: topContainerView.leadingAnchor,
                            trailing: topContainerView.trailingAnchor,
                            padding: .init(top: 5, left: 20, bottom: 0, right: 20))
        lineView1.anchor(top: bodyLabel.bottomAnchor,
                         leading: topContainerView.leadingAnchor,
                         trailing: topContainerView.trailingAnchor,
                         padding: .init(top: 10, left: 20, bottom: 0, right: 20),
                         size: .init(width: 0, height: 1))
        toggle.anchor(top: lineView1.bottomAnchor,
                      trailing: topContainerView.trailingAnchor,
                      padding: .init(top: 5, left: 0, bottom: 0, right: 20))
        toggleLabel.anchor(top: lineView1.bottomAnchor,
                           leading: topContainerView.leadingAnchor,
                           bottom: lineView2.topAnchor,
                           trailing: toggle.leadingAnchor,
                           padding: .init(top: 0, left: 20, bottom: 0, right: 20))
        lineView2.anchor(top: toggle.bottomAnchor,
                         leading: topContainerView.leadingAnchor,
                         trailing: topContainerView.trailingAnchor,
                         padding: .init(top: 5, left: 20, bottom: 0, right: 20),
                         size: .init(width: 0, height: 1))
        textField.anchor(top: lineView2.bottomAnchor,
                         padding: .init(top: 10, left: 0, bottom: 0, right: 0),
                         size: .init(width: 200, height: 30))
        textField.centerHorizontallyInSuperview()
        lineView3.anchor(top: textField.bottomAnchor,
                         leading: topContainerView.leadingAnchor,
                         bottom: topContainerView.bottomAnchor,
                         trailing: topContainerView.trailingAnchor,
                         padding: .init(top: 10, left: 20, bottom: 0, right: 20),
                         size: .init(width: 0, height: 1))
    }

    func reloadTableView() {
        self.tableViewHeight?.constant = CGFloat(self.reminderCount*60)+10
        UIView.transition(with: tableView, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.tableView.reloadData()

        })
    }

    @objc func doneTapped() {
        self.textField.resignFirstResponder()
        let row = self.picker.selectedRow(inComponent: 0)
        let isGoingDown = row+1 < reminderCount ? true : false
        let title = row == 0 ? "Daily Reminder" : "Daily Reminders"
        textField.text = "\(row+1) \(title)"
        reminderCount = row+1
        scrollView.setContentOffset(CGPoint(x: -scrollView.adjustedContentInset.left,   // Scroll to top of page
                                            y: -scrollView.adjustedContentInset.top),
                                    animated: true)
        switch isGoingDown { // if true, removes excess height after animation. Otherwise before. Needed for smoothness.
        case true:
            UIView.transition(with: tableView, duration: 1.0, options: .transitionCrossDissolve, animations: {
                self.tableView.reloadData()

            }, completion: {_ in
                self.tableViewHeight?.constant = CGFloat(self.reminderCount*60)+10
            })
        case false:
            self.tableViewHeight?.constant = CGFloat(self.reminderCount*60)+10
            UIView.transition(with: tableView, duration: 1.0, options: .transitionCrossDissolve, animations: {
                self.tableView.reloadData()

            })
        }
    }

    @objc func switchValueDidChange(_ sender: UISwitch!) {
        print("switch \(sender.isOn)")
    }
}

extension NotificationsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return presenter.numberOfRowsInSection()
        return reminderCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: cellId) as?
                NotificationsTableViewCell else {
            return UITableViewCell()
        }
//        presenter.notificationTimeStampForRow(row: indexPath.row, completion: { timeStamp in
//            DispatchQueue.main.async {
//                cell.timeStampLabel.text = timeStamp
//            }
//        })
        return cell
    }
}

extension NotificationsView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        25
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let title = row == 0 ? "Daily Reminder" : "Daily Reminders"
        return "\(row+1) \(title)"
    }
}
