import UIKit

class SettingsDetailView: UIViewController {

    enum SettingsType {
        case goal
        case favourite
        case coefficient
    }

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()

    let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.backgroundColor = .infoPanelBG
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        return button
    }()

    let goalLabel: UILabel = {
        let label = UILabel()
        label.textColor = .whiteText
        label.font = UIFont.SFProRounded(ofSize: 30, fontWeight: .medium)
        label.textAlignment = .center
        return label
    }()

    var goalValue: Double = 2000

    var settingsType: SettingsType = .goal
    var userDefaultsController: UserDefaultsControllerProtocol! = UserDefaultsController.shared

    override func viewDidLoad() {
        self.navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .black

        view.addSubview(saveButton)
        saveButton.anchor(top: nil,
                          leading: view.leadingAnchor,
                          bottom: view.safeAreaLayoutGuide.bottomAnchor,
                          trailing: view.trailingAnchor,
                          padding: .init(top: 0, left: 35, bottom: 20, right: 35),
                          size: .init(width: 0, height: 50))

        view.addSubview(stackView)
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         leading: view.leadingAnchor,
                         bottom: saveButton.topAnchor,
                         trailing: view.trailingAnchor,
                         padding: .init(top: 0, left: 35, bottom: 0, right: 35))



        switch settingsType {
        case .goal:
            setupGoalView()
        case .favourite:
            print("do something")
        case .coefficient:
            print("do something")
        }
    }

    func setupGoalView() {
        title = "Change Goal"
        let currentGoal = userDefaultsController.drinkGoal
        goalLabel.text = "\(Int(currentGoal))ml"
        goalValue = currentGoal

        let headingLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            label.textColor = .whiteText
            label.text = "Need to update your goal?"
            return label
        }()

        let bodyLabel: UILabel = {
            let label = UILabel()
            label.textColor = .lightGray
            label.font = UIFont.systemFont(ofSize: 15, weight: .light)
            label.numberOfLines = 0
            label.text = """
                        This number is how much you plan to drink daily. It's okay if you need to change it. \
                        It's normal to play around with it a few times until it feels just right.

                        Adjust the slider below to amend it to your liking. \
                        It has a minimum of 1000ml and a maximum of 4000ml.

                        Note: Changing the goal does not affect days that already have a drink entry.
                        """
            return label
        }()


        let slider: UISlider = {
            let slider = UISlider()
            slider.minimumValue = 1000
            slider.maximumValue = 4000
            slider.isContinuous = true
            slider.tintColor = UIColor.dripMerged
            slider.value = Float(currentGoal)
            return slider
        }()

        slider.addTarget(self, action: #selector(self.sliderValueDidChange(_:)), for: .valueChanged)

        let spacer1 = UIView(), spacer2 = UIView(), spacer3 = UIView(), spacer4 = UIView(), spacer5 = UIView()

        let subViews = [spacer1, headingLabel, spacer2, bodyLabel, spacer3, goalLabel, spacer4, slider, spacer5]
        subViews.forEach({stackView.addArrangedSubview($0)})

        spacer1.translatesAutoresizingMaskIntoConstraints = false
        spacer2.translatesAutoresizingMaskIntoConstraints = false
        spacer3.translatesAutoresizingMaskIntoConstraints = false
        spacer4.translatesAutoresizingMaskIntoConstraints = false
        spacer5.translatesAutoresizingMaskIntoConstraints = false

        spacer5.heightAnchor.constraint(equalTo: spacer1.heightAnchor, multiplier: 0.9).isActive = true
        spacer3.heightAnchor.constraint(equalTo: spacer1.heightAnchor, multiplier: 0.5).isActive = true
        spacer4.heightAnchor.constraint(equalTo: spacer1.heightAnchor, multiplier: 0.25).isActive = true
        spacer2.heightAnchor.constraint(equalTo: spacer1.heightAnchor, multiplier: 0.1).isActive = true

        saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
    }

    @objc func sliderValueDidChange(_ sender: UISlider!) {
        let step: Float = 50
        let roundedStepValue = round(sender.value / step) * step
        sender.value = roundedStepValue

        goalValue = Double(roundedStepValue)
        goalLabel.text = "\(Int(roundedStepValue))ml"
    }

    @objc func saveButtonAction() {
        switch settingsType {
        case .goal:
            userDefaultsController.drinkGoal = goalValue
        default:
            print("do nothing")
        }

        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
}

