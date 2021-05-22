import UIKit

class NotificationsView: UIViewController, NotificationsViewProtocol {
    var presenter: NotificationsPresenterProtocol!
    var userDefaultsController: UserDefaultsControllerProtocol!
    var notificationController: LocalNotificationControllerProtocol!

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
        toggle.isOn = true
        return toggle
    }()

    let textField: UITextField = {
        let textField = UITextField()
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

    var tableViewHeight: NSLayoutConstraint?

    override func viewDidLoad() {
        self.navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .black

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NotificationsTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.isScrollEnabled = false

        presenter.onViewDidLoad()

        let backButton = UIBarButtonItem()
        backButton.title = "Save"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.onViewWillAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        presenter.onViewWillDisappear()
        super.viewWillDisappear(animated)
    }

    func updateTitle(title: String) {
        self.title = title
    }

    func presentView(_ view: UIViewController) {
        present(view, animated: true, completion: nil)
    }

    func setupNotificationsView(headingText: String, bodyText: String) {
        toggle.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)

        picker.delegate = self
        picker.dataSource = self

        picker.backgroundColor = .infoPanelBG

        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
        toolBar.barStyle = UIBarStyle.black
        toolBar.isTranslucent = true
        toolBar.tintColor = .gray
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
                                             constant: CGFloat(presenter.numberOfRowsInSection()*60)+10)
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
        DispatchQueue.main.async {
            self.tableViewHeight?.constant = CGFloat(self.presenter.numberOfRowsInSection()*60)+10
            UIView.transition(with: self.tableView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.tableView.reloadData()

            })
        }
    }

    func updateReminderCountTitle(count: Int) {
        let title = count == 1 ? "\(count) Daily Reminder" : "\(count) Daily Reminders"
        textField.text = title
    }

    func setPickerRow(row: Int) {
        picker.selectRow(row, inComponent: 0, animated: false)
    }

    @objc func doneTapped() {
        self.textField.resignFirstResponder()
        let row = self.picker.selectedRow(inComponent: 0)
        let title = row == 0 ? "Daily Reminder" : "Daily Reminders"
        presenter.setReminderCount(to: row+1)

        textField.text = "\(row+1) \(title)"
    }

    @objc func switchValueDidChange(_ sender: UISwitch!) {
        presenter.onSwitchToggle(isOn: sender.isOn)
    }

    func resetPicker() {
        DispatchQueue.main.async {
            self.textField.text = "3 Daily Reminders"
            self.setPickerRow(row: 2)
        }
    }

    func setToggleStatus(isOn: Bool) {
        DispatchQueue.main.async {
            self.toggle.isOn = isOn
            self.tableView.isHidden = !isOn
            self.textField.isEnabled = isOn
            self.textField.isHidden = !isOn
            self.lineView3.isHidden = !isOn
        }
    }

    func showSettingsNotificationDialogue() {
        DispatchQueue.main.async {
            let message = "Please enable notifications in System Settings if you want to receive reminders."
            let alertContoller = UIAlertController(title: "Enable Notifications",
                                                   message: message,
                                                   preferredStyle: .alert)

            let settingsAction = UIAlertAction(title: "Open Settings", style: .default) { _ in
                if let bundleIdentifier = Bundle.main.bundleIdentifier, let appSettings =
                    URL(string: UIApplication.openSettingsURLString + bundleIdentifier) {
                    if UIApplication.shared.canOpenURL(appSettings) {
                        UIApplication.shared.open(appSettings)
                    }
                }
            }

            let cancelAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)

            alertContoller.addAction(cancelAction)
            alertContoller.addAction(settingsAction)

            self.present(alertContoller, animated: true)
        }
    }
}

extension NotificationsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("is being called")
        return presenter.numberOfRowsInSection()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: cellId) as?
                NotificationsTableViewCell else {
            return UITableViewCell()
        }
        cell.timeStampLabel.text = presenter.timeStampForRow(row: indexPath.row)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notificationData = presenter.getNotificationInfoForRow(row: indexPath.row)
        let detailView = NotificationDetailScreenBuilder(notification: notificationData).build()
        detailView.delegate = self
        let embeddedVC = DarkNavController(rootViewController: detailView)
        present(embeddedVC, animated: true, completion: nil)
    }
}

extension NotificationsView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        25
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int,
                    forComponent component: Int) -> NSAttributedString? {
        let title = row == 0 ? "\(row+1) Daily Reminder" : "\(row+1) Daily Reminders"
        return NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
}

extension NotificationsView: NotificationDetailDelegate {
    func updateReminder(notification: Notification) {
        presenter.amendReminder(notification: notification)
    }
}
