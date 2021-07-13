import UIKit

extension SettingsDetailView {

    func setupButton() {
        view.addSubview(saveButton)
        saveButton.anchor(top: nil,
                          leading: view.leadingAnchor,
                          bottom: view.safeAreaLayoutGuide.bottomAnchor,
                          trailing: view.trailingAnchor,
                          padding: .init(top: 0, left: 35, bottom: 20, right: 35),
                          size: .init(width: 0, height: 50))
        saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
    }

    func setupStackView() {
        view.addSubview(stackView)
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         leading: view.leadingAnchor,
                         bottom: saveButton.topAnchor,
                         trailing: view.trailingAnchor,
                         padding: .init(top: 0, left: 35, bottom: 0, right: 35))
    }

    func setupGoalView(currentGoal: Double, headingText: String, bodyText: String) {
        goalLabel.text = "\(Int(currentGoal))ml"

        headingLabel.text = headingText
        bodyLabel.text = bodyText
        saveButton.setTitle("Save", for: .normal)

        setupButton()
        setupStackView()

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

        spacer2.equalHeightTo(spacer1, multiplier: 0.1)
        spacer3.equalHeightTo(spacer1, multiplier: 0.5)
        spacer4.equalHeightTo(spacer1, multiplier: 0.25)
        spacer5.equalHeightTo(spacer1, multiplier: 0.9)
    }

    func setupFavouritesView(headingText: String, bodyText: String) {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DrinksCell.self, forCellWithReuseIdentifier: cellId)
        drinksLauncher.delegate = self

        headingLabel.text = headingText
        bodyLabel.text = bodyText
        saveButton.setTitle("Finished", for: .normal)

        setupButton()
        setupStackView()

        let spacer1 = UIView(), spacer2 = UIView(), spacer3 = UIView(), spacer4 = UIView(),
            collectionViewContainer = UIView()

        collectionViewContainer.addSubview(collectionView)

        collectionView.anchor(top: collectionViewContainer.topAnchor,
                              leading: nil,
                              bottom: collectionViewContainer.bottomAnchor,
                              padding: .init(top: 0, left: 0, bottom: 0, right: 0),
                              size: .init(width: 250, height: 250))
        collectionView.centerHorizontallyInSuperview()

        let subViews = [spacer1, headingLabel, spacer2, bodyLabel, spacer3, collectionViewContainer, spacer4]
        subViews.forEach({stackView.addArrangedSubview($0)})

        spacer4.equalHeightTo(spacer1, multiplier: 0.9)
        spacer3.equalHeightTo(spacer1, multiplier: 0.5)
        spacer2.equalHeightTo(spacer1, multiplier: 0.1)

    }

    // swiftlint:disable:next function_body_length
    func setupCoefficientView(headingText: String, bodyText: String) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CoefficientTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.isScrollEnabled = false

        let childStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.alignment = .fill
            stackView.distribution = .fill
            return stackView
        }()

        toggle.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)

        let toggleLabel: UILabel = {
            let label = UILabel()
            label.textColor = .whiteText
            label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            label.text = "Enable Drink Coefficients"
            return label
        }()

        let topContainerView = UIView(), lineView1 = UIView(), lineView2 = UIView()

        view.addSubview(scrollView)
        scrollView.addSubview(childStackView)

        lineView1.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        lineView2.backgroundColor = UIColor.white.withAlphaComponent(0.2)

        let subViews = [headingLabel, bodyLabel, lineView1, toggleLabel, toggle, lineView2]
        subViews.forEach({topContainerView.addSubview($0)})

        let arrangedSubviews = [topContainerView, tableView]
        arrangedSubviews.forEach({childStackView.addArrangedSubview($0)})

        scrollView.fillSuperView()
        childStackView.fillSuperView()
        childStackView.setEqualWidthTo(scrollView)

        headingLabel.text = headingText
        bodyLabel.text = bodyText

        tableViewHeight = NSLayoutConstraint(item: tableView,
                                             attribute: .height,
                                             relatedBy: .equal,
                                             toItem: nil, attribute: .notAnAttribute,
                                             multiplier: 1,
                                             constant: CGFloat((presenter.numberOfRowsInSection()*90))+10)
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
                         bottom: topContainerView.bottomAnchor,
                         trailing: topContainerView.trailingAnchor,
                         padding: .init(top: 5, left: 20, bottom: 0, right: 20),
                         size: .init(width: 0, height: 1))
    }

    // swiftlint:disable:next function_body_length
    func setupHealthKitView(headingText: String, bodyText: String) {
        toggle.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
        toggle.isOn = userDefaultsController.enabledHealthKit

        let toggleLabel: UILabel = {
            let label = UILabel()
            label.textColor = .whiteText
            label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            label.text = "Enable Health Kit Integration"
            return label
        }()

        let topContainerView = UIView(), lineView1 = UIView(), lineView2 = UIView()

        view.addSubview(topContainerView)

        lineView1.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        lineView2.backgroundColor = UIColor.white.withAlphaComponent(0.2)

        let subViews = [headingLabel, bodyLabel, lineView1, toggleLabel, toggle, lineView2]
        subViews.forEach({topContainerView.addSubview($0)})

        headingLabel.text = headingText
        bodyLabel.text = bodyText

        topContainerView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                leading: view.leadingAnchor,
                                trailing: view.trailingAnchor)

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
                         bottom: topContainerView.bottomAnchor,
                         trailing: topContainerView.trailingAnchor,
                         padding: .init(top: 5, left: 20, bottom: 0, right: 20),
                         size: .init(width: 0, height: 1))
    }

    func setupAttributionView(headingText: String, bodyText: String) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorColor = UIColor.white.withAlphaComponent(0.2)
        tableView.tableFooterView = UIView()

        let subViews = [headingLabel, bodyLabel, tableView]
        subViews.forEach({view.addSubview($0)})

        headingLabel.text = headingText
        bodyLabel.text = bodyText

        headingLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                            leading: view.leadingAnchor,
                            trailing: view.trailingAnchor,
                            padding: .init(top: 10, left: 20, bottom: 0, right: 20))
        bodyLabel.anchor(top: headingLabel.bottomAnchor,
                            leading: view.leadingAnchor,
                            trailing: view.trailingAnchor,
                            padding: .init(top: 5, left: 20, bottom: 0, right: 20))
        tableView.anchor(top: bodyLabel.bottomAnchor,
                         leading: view.leadingAnchor,
                         bottom: view.bottomAnchor,
                         trailing: view.trailingAnchor,
                         padding: .init(top: 5, left: 0, bottom: 0, right: 0))
    }

    func setupAboutView(headingText: String, bodyText: String) {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "portrait")
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true

        headingLabel.text = headingText
        bodyLabel.text = bodyText

        saveButton.setTitle("Back", for: .normal)

        setupButton()

        let subViews = [imageView, headingLabel, bodyLabel]
        subViews.forEach({view.addSubview($0)})

        imageView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         padding: .init(top: 10, left: 0, bottom: 0, right: 0),
                         size: .init(width: 150, height: 150))
        imageView.centerHorizontallyInSuperview()
        headingLabel.anchor(top: imageView.bottomAnchor,
                            leading: view.leadingAnchor,
                            trailing: view.trailingAnchor,
                            padding: .init(top: 10, left: 20, bottom: 0, right: 20))
        bodyLabel.anchor(top: headingLabel.bottomAnchor,
                            leading: view.leadingAnchor,
                            trailing: view.trailingAnchor,
                            padding: .init(top: 5, left: 20, bottom: 0, right: 20))

    }
}
