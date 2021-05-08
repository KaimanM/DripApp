import UIKit

protocol NotificationsTableViewCellDelegate: class {
    func didChangeDate(date: Date, tag: Int)
}

class NotificationsTableViewCell: UITableViewCell {

    weak var delegate: NotificationsTableViewCellDelegate?

    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .infoPanelBG
        view.layer.cornerRadius = 10
        return view
    }()

    let reminderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFProRounded(ofSize: 18, fontWeight: .semibold)
        label.textColor = .dripMerged
        label.adjustsFontSizeToFitWidth = true
        label.text = "Reminder at"
        return label
    }()

    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .inline
        return datePicker
    }()

    let timeStampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFProRounded(ofSize: 18, fontWeight: .semibold)
        label.textColor = .whiteText
        label.text = "16:34 PM"
        label.textAlignment = .right
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear

        contentView.addSubview(containerView)

        containerView.anchor(top: contentView.topAnchor,
                             leading: contentView.leadingAnchor,
                             bottom: contentView.bottomAnchor,
                             trailing: contentView.trailingAnchor,
                             padding: .init(top: 5, left: 15, bottom: 5, right: 15),
                             size: .init(width: 0, height: 50))

        containerView.addSubview(reminderLabel)
//        containerView.addSubview(timeStampLabel)
        containerView.addSubview(datePicker)

        datePicker.anchor(top: containerView.topAnchor,
                              leading: nil,
                              bottom: containerView.bottomAnchor,
                              trailing: containerView.trailingAnchor,
                              padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        datePicker.centerVerticallyInSuperview()
//        datePicker.fillSuperViewSafely()
        datePicker.addTarget(self, action: #selector(datePickerChanged(sender:)), for: .valueChanged)

        reminderLabel.anchor(top: nil,
                             leading: containerView.leadingAnchor,
                             bottom: nil,
                             trailing: datePicker.leadingAnchor,
                             padding: .init(top: 0, left: 20, bottom: 0, right: 0))
        reminderLabel.centerVerticallyInSuperview()
    }

    @objc func datePickerChanged(sender: UIDatePicker) {
        
        delegate?.didChangeDate(date: sender.date, tag: tag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
}
