import UIKit

protocol NotificationDetailDelegate: AnyObject {
    func updateReminder(notification: Notification)
}

class NotificationDetailView: UIViewController, NotificationDetailViewProtocol {
    var presenter: NotificationDetailPresenterProtocol!
    var notification: Notification!

    weak var delegate: NotificationDetailDelegate?

    let containerView = UIView()

    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .inline
        datePicker.overrideUserInterfaceStyle = .dark
        return datePicker
    }()

    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.isScrollEnabled = false
        tableView.separatorColor = UIColor.white.withAlphaComponent(0.2)
        tableView.contentInset.top = -35 // Removes padding caused by grouped style
        return tableView
    }()

    let options = ["Message", "Sound"]

    func updateTitle(title: String) {
        self.title = title
    }

    override func viewDidLoad() {
        title = "Edit Reminder"
        view.backgroundColor = .infoPanelDark

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                                style: .plain,
                                                                target: self, action: #selector(cancelTapped))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                                 style: .plain,
                                                                 target: self, action: #selector(saveTapped))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        setupSubviews()

        datePicker.date = notification.timeStamp.date!
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)

    }

    func setupSubviews() {
        view.addSubview(containerView)
        view.addSubview(tableView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                             leading: view.leadingAnchor,
                             trailing: view.trailingAnchor,
                             size: .init(width: 0, height: 120))
//        containerView.backgroundColor = .red

        let timeLabel = UILabel()
        timeLabel.text = "Time"
        timeLabel.textColor = .whiteText

        containerView.addSubview(timeLabel)
        timeLabel.anchor(leading: containerView.leadingAnchor,
                         padding: .init(top: 0, left: 20, bottom: 0, right: 0))
        timeLabel.centerVerticallyInSuperview()

        containerView.addSubview(datePicker)
        datePicker.anchor(trailing: containerView.trailingAnchor,
                         padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        datePicker.centerVerticallyInSuperview()

        tableView.anchor(top: containerView.bottomAnchor,
                         leading: view.leadingAnchor,
                         trailing: view.trailingAnchor,
                         size: .init(width: 0, height: 88)) // no of rows in section x44
    }

    @objc func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc func saveTapped() {
        delegate?.updateReminder(notification: notification)
        dismiss(animated: true, completion: nil)
    }

    @objc func toggleDidChange(_ sender: UISwitch) {
        switch sender.isOn {
        case true:
            notification.sound = true
        case false:
            notification.sound = false
        }
    }

    @objc func textFieldDidFinishEditing(_ sender: UITextField) {
        if let text = sender.text, !text.isEmpty {
            notification.body = text
        }
    }

    @objc func datePickerChanged(_ sender: UIDatePicker) {
        let hour = Calendar.current.component(.hour, from: sender.date)
        let minute = Calendar.current.component(.minute, from: sender.date)
        notification.timeStamp = DateComponents(calendar: Calendar.current,
                                                hour: hour, minute: minute)
    }
}

extension NotificationDetailView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "cellId") else {
            return UITableViewCell() }
        cell.backgroundColor = .infoPanelBG
        cell.textLabel?.textColor = .whiteText
        switch indexPath.row {
        case 0:
            let textField = UITextField(frame: .zero)
            textField.addTarget(self, action: #selector(textFieldDidFinishEditing), for: .editingDidEnd)
            textField.attributedPlaceholder = NSAttributedString(string: notification.body,
                                                                 attributes: [NSAttributedString.Key.foregroundColor:
                                                                                UIColor.white.withAlphaComponent(0.3)])
            textField.textColor = .whiteText
            textField.returnKeyType = UIReturnKeyType.done
            textField.textAlignment = .right
            textField.clearButtonMode = .whileEditing
            textField.delegate = self
            if let button = textField.value(forKey: "clearButton") as? UIButton {
              button.tintColor = .darkGray
              button.setImage(UIImage(systemName: "xmark.circle.fill")?.withRenderingMode(.alwaysTemplate),
                              for: .normal)
            }
            cell.contentView.addSubview(textField)
            textField.anchor(trailing: cell.contentView.trailingAnchor,
                             padding: .init(top: 0, left: 0, bottom: 0, right: 20),
                             size: .init(width: 200, height: 0))
            textField.centerVerticallyInSuperview()
        case 1:
            let toggle = UISwitch(frame: .zero)
            toggle.isOn = true
            toggle.tag = indexPath.row
            toggle.addTarget(self, action: #selector(toggleDidChange), for: .valueChanged)
            toggle.onTintColor = .dripMerged
            cell.accessoryView = toggle
        default:
            let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
            cell.accessoryView = chevronImageView
        }
        cell.tintColor = UIColor.white.withAlphaComponent(0.2)
        cell.textLabel?.text = options[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

extension NotificationDetailView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textField.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        // make sure the result is under 16 characters
        return updatedText.count <= 25
    }
}
