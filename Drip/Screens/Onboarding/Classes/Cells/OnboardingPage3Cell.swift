import UIKit

protocol OnboardingPage3CellDelegate: class {
    func didTapPage3Button(name: String, goal: Double)
}

class OnboardingPage3Cell: UICollectionViewCell {

    weak var delegate : OnboardingPage3CellDelegate?

    let continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .infoPanelBG
        button.layer.cornerRadius = 10
        return button
    }()

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()

    let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()

    let heading1Label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .whiteText
        label.text = "What should we call you?"
        return label
    }()

    let body1Label: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.text = "It doesn’t have to be your real name. How does Buddy or Pal sound?"
        label.numberOfLines = 0
        return label
    }()

    let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Buddy"
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return textField
    }()

    let heading2Label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .whiteText
        label.text = "Let's set a goal!"
        return label
    }()

    let body2Label: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.numberOfLines = 0
        label.text = """
                    How much are you aiming to drink daily? We've set it at 2500ml \
                    but you can tune it to your liking!
                    """
        return label
    }()

    let goalLabel: UILabel = {
        let label = UILabel()
        label.textColor = .whiteText
        label.font = UIFont.SFProRounded(ofSize: 30, fontWeight: .medium)
        label.text = "2500ml"
        return label
    }()

    let slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 1000
        slider.maximumValue = 4000
        slider.isContinuous = true
        slider.tintColor = UIColor.dripMerged
        return slider
    }()

    var goalValue: Double = 2500

    var name = "Buddy"

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .black
        textField.delegate = self
        contentView.addSubview(continueButton)
        continueButton.anchor(leading: contentView.leadingAnchor,
                              bottom: contentView.bottomAnchor,
                              trailing: contentView.trailingAnchor,
                              padding: .init(top: 0, left: 35, bottom: 20, right: 35),
                              size: .init(width: 0, height: 50))
        continueButton.addTarget(self, action: #selector(continueButtonAction), for: .touchUpInside)
        contentView.addSubview(stackView)
        stackView.anchor(top: contentView.topAnchor,
                         leading: contentView.leadingAnchor,
                         bottom: continueButton.topAnchor,
                         trailing: contentView.trailingAnchor)
        slider.addTarget(self, action: #selector(self.sliderValueDidChange(_:)), for: .valueChanged)
        slider.value = 2500
        populateStackView()
    }

    @objc func sliderValueDidChange(_ sender: UISlider!) {
        let step: Float = 50
        let roundedStepValue = round(sender.value / step) * step
        sender.value = roundedStepValue

        goalValue = Double(roundedStepValue)
        goalLabel.text = "\(Int(roundedStepValue))ml"
    }

    func populateStackView() {
        let spacer1 = UIView(), spacer2 = UIView(), spacer3 = UIView(), titleContainerView = UIView()

        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "Before we begin"
            label.textColor = .whiteText
            label.textAlignment = .left
            label.font = UIFont.systemFont(ofSize: 38, weight: .heavy)
            label.adjustsFontSizeToFitWidth = true
            return label
        }()
        let subtitleLabel: UILabel = {
            let label = UILabel()
            label.textColor = .lightGray
            label.font = UIFont.systemFont(ofSize: 15, weight: .light)
            label.numberOfLines = 0
            return label
        }()
        subtitleLabel.text = """
                            Before we begin, let’s choose a few options to help us give you \
                            the best experience possible!
                            """

        titleContainerView.addSubview(titleLabel)
        titleContainerView.addSubview(subtitleLabel)
        titleLabel.anchor(top: titleContainerView.topAnchor,
                               leading: titleContainerView.leadingAnchor,
                               trailing: titleContainerView.trailingAnchor,
                               padding: .init(top: 0, left: 25, bottom: 0, right: 25))
        subtitleLabel.anchor(top: titleLabel.bottomAnchor,
                          leading: titleContainerView.leadingAnchor,
                          bottom: titleContainerView.bottomAnchor,
                          trailing: titleContainerView.trailingAnchor,
                          padding: .init(top: 0, left: 25, bottom: 0, right: 35))

        let arrangedSubviews = [spacer1, titleContainerView, spacer2, contentStackView, spacer3]
        arrangedSubviews.forEach({stackView.addArrangedSubview($0)})

        spacer2.equalHeightTo(spacer1, multiplier: 0.5)
        spacer1.equalHeightTo(spacer3, multiplier: 0.6)

        contentStackView.anchor(size: .init(width: contentView.frame.width, height: 370))
        populateContentStackView()
    }

    // swiftlint:disable:next function_body_length
    func populateContentStackView() {
        let spacer1 = UIView(), spacer2 = UIView(), spacer3 = UIView(),
            topContainerView = UIView(), bottomContainerView = UIView()

        let topSubviews = [heading1Label, body1Label, textField]
        topSubviews.forEach({topContainerView.addSubview($0)})

        heading1Label.anchor(top: topContainerView.topAnchor,
                             leading: topContainerView.leadingAnchor,
                             trailing: topContainerView.trailingAnchor,
                             padding: .init(top: 0, left: 35, bottom: 0, right: 35))
        body1Label.anchor(top: heading1Label.bottomAnchor,
                             leading: topContainerView.leadingAnchor,
                             trailing: topContainerView.trailingAnchor,
                             padding: .init(top: 5, left: 35, bottom: 0, right: 35))
        textField.anchor(top: body1Label.bottomAnchor,
                             leading: topContainerView.leadingAnchor,
                             bottom: topContainerView.bottomAnchor,
                             trailing: topContainerView.trailingAnchor,
                             padding: .init(top: 15, left: 35, bottom: 0, right: 35))

        let bottomSubviews = [heading2Label, body2Label, goalLabel, slider]
        bottomSubviews.forEach({bottomContainerView.addSubview($0)})

        heading2Label.anchor(top: bottomContainerView.topAnchor,
                             leading: bottomContainerView.leadingAnchor,
                             trailing: bottomContainerView.trailingAnchor,
                             padding: .init(top: 0, left: 35, bottom: 0, right: 35))
        body2Label.anchor(top: heading2Label.bottomAnchor,
                             leading: bottomContainerView.leadingAnchor,
                             trailing: bottomContainerView.trailingAnchor,
                             padding: .init(top: 5, left: 35, bottom: 0, right: 35))
        goalLabel.anchor(top: body2Label.bottomAnchor,
                             padding: .init(top: 10, left: 0, bottom: 0, right: 0))
        goalLabel.centerHorizontallyInSuperview()
        slider.anchor(top: goalLabel.bottomAnchor,
                      leading: bottomContainerView.leadingAnchor,
                      bottom: bottomContainerView.bottomAnchor,
                      trailing: bottomContainerView.trailingAnchor,
                      padding: .init(top: 10, left: 35, bottom: 0, right: 35))

        let arrangedSubviews = [spacer1, topContainerView, spacer2, bottomContainerView, spacer3]
        arrangedSubviews.forEach({contentStackView.addArrangedSubview($0)})

        // constraints so content is just above offcenter in screen
        spacer1.equalHeightTo(spacer2, multiplier: 0.45)
        spacer3.equalHeightTo(spacer2, multiplier: 0.45)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func continueButtonAction(sender: UIButton!) {
        delegate?.didTapPage3Button(name: name, goal: goalValue)
    }

}

extension OnboardingPage3Cell: UITextFieldDelegate {
        func textFieldDidEndEditing(_ textField: UITextField) {
            if let name = textField.text, !name.isEmpty {
                print("entered name is \(name)")
                self.name = name
            } else {
                print("name empty, setting name to buddy")
                self.name = "Buddy"
            }
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            // called when 'return' key pressed. return NO to ignore.
            print("TextField should return method called")
            textField.resignFirstResponder()
            return true
        }
}
