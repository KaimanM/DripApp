//
//  NotifDetailVC.swift
//  Drip
//
//  Created by Kaiman Mehmet on 09/05/2021.
//  Copyright © 2021 Kaiman Mehmet. All rights reserved.
//

import UIKit

protocol NotifDetailDelegate: AnyObject {
    func changeTitle(title: String)
    func updateReminder(timeStamp: Date, repeating: Bool, message: String, sound: Bool)
}

class NotifDetailVC: UIViewController, UINavigationBarDelegate {

    weak var delegate: NotifDetailDelegate?

    var timeStamp: Date = Date()
    var repeating = true
    var message = "Let's have a drink!"
    var sound = true

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

    let options = ["Repeat", "Message", "Sound"]

    convenience init(timeStamp: Date, repeating: Bool, message: String, sound: Bool) {
        self.init()
        self.timeStamp = timeStamp
        self.repeating = repeating
        self.message = message
        self.sound = sound
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
                         size: .init(width: 0, height: 132)) // no of rows in section x44
    }

    @objc func cancelTapped() {
        delegate?.changeTitle(title: "hehe xd")
        dismiss(animated: true, completion: nil)
    }

    @objc func saveTapped() {
        delegate?.updateReminder(timeStamp: timeStamp,
                                 repeating: repeating,
                                 message: message,
                                 sound: sound)
    }

    @objc func toggleDidChange(_ sender: UISwitch) {
        print(sender.isOn)
    }

    @objc func textFieldDidFinishEditing(_ sender: UITextField) {
        print(sender.text)
    }
}

extension NotifDetailVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "cellId") else {
            return UITableViewCell() }
        cell.backgroundColor = .infoPanelBG
        cell.textLabel?.textColor = .whiteText
        switch indexPath.row {
        case 0, 2:
            let toggle = UISwitch(frame: .zero)
            toggle.isOn = true
            toggle.tag = indexPath.row
            toggle.addTarget(self, action: #selector(toggleDidChange), for: .valueChanged)
            toggle.onTintColor = .dripMerged
            cell.accessoryView = toggle
        case 1:
            let textField = UITextField(frame: .zero)
            textField.addTarget(self, action: #selector(textFieldDidFinishEditing), for: .editingDidEnd)
            textField.placeholder = "Let's have a drink!"
            textField.returnKeyType = UIReturnKeyType.done
            textField.textAlignment = .right
            textField.clearButtonMode = .whileEditing
            textField.delegate = self
            cell.contentView.addSubview(textField)
            textField.anchor(top: nil,
                             leading: nil,
                             bottom: nil,
                             trailing: cell.contentView.trailingAnchor,
                             padding: .init(top: 0, left: 0, bottom: 0, right: 20),
                             size: .init(width: 200, height: 0))
            textField.centerVerticallyInSuperview()
        default:
            let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
            cell.accessoryView = chevronImageView
        }
        cell.tintColor = UIColor.white.withAlphaComponent(0.2)
        cell.textLabel?.text = options[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

extension NotifDetailVC: UITextFieldDelegate {
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
