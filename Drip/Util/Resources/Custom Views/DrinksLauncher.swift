import UIKit

protocol DrinksLauncherDelegate: class {
    func didAddDrink(beverage: Beverage, volume: Double)
}

// swiftlint:disable:next type_body_length
class DrinksLauncher: NSObject {

    // MARK: - Properties -
    weak var delegate: DrinksLauncherDelegate?

    // Required UI initialization
    let blackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()

    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .infoPanelBG
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()

    let page1 = UIView()
    let page2 = UIView()

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.isScrollEnabled = false
        return scrollView
    }()

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    let horizontalSV: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.backgroundColor = .clear
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()

    let drinkNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Water"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()

    let page1TitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 19.0)
        return label
    }()

    let detailImageView = UIImageView()

    let picker = UIPickerView()

    let contentView1 = QuickDrinkView()
    let contentView2 = QuickDrinkView()
    let contentView3 = QuickDrinkView()
    let contentView4 = QuickDrinkView()

    let pageControl = UIPageControl()

    let cellId = "cellId"
    var origin = CGPoint(x: 0, y: 0)
    var viewTranslation = CGPoint(x: 0, y: 0)

    // Data values initilization
    let drinkVolumeArray = ["50ml", "100ml", "150ml", "200ml", "250ml", "300ml", "350ml", "400ml",
                            "450ml", "500ml", "550ml", "600ml", "650ml", "700ml", "750ml", "800ml",
                            "850ml", "900ml", "1000ml"]

    var currentVolume: Double = 300

    let beverages = Beverages().drinks
    var currentBeverage = Beverage(name: "Water", imageName: "waterbottle.svg", coefficient: 1)

    var isFirstOpen = true

    let userDefaults: UserDefaultsControllerProtocol

    var isOnboarding = true

    init(userDefaults: UserDefaultsControllerProtocol, isOnboarding: Bool) {
        self.isOnboarding = isOnboarding
        self.userDefaults = userDefaults
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        pageControl.isUserInteractionEnabled = false
        picker.dataSource = self
        picker.delegate = self

        collectionView.register(DrinksCell.self, forCellWithReuseIdentifier: cellId)
        setupViews()
        setupStackView()
    }

    func showDrinks() {
        reloadQuickDrinks()

        if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
            let height: CGFloat = 460
            let yOffset = window.frame.height - height

            addToSuperView(window: window)
            if isFirstOpen { firstTimeOpenConstraints(window: window, height: height) }

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1,
                           initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                            self.blackView.alpha = 1
                            self.containerView.frame = CGRect(x: 0, y: yOffset,
                                                              width: self.containerView.frame.width,
                                                              height: self.containerView.frame.height)
                           }, completion: {_ in
                            // sets origin so it knows where to bounce back to when container dragged around
                            self.origin = self.containerView.frame.origin
                           })
        }
    }

    // MARK: - UI Initilization -
    func firstTimeOpenConstraints(window: UIWindow, height: CGFloat) {
        blackView.frame = window.frame
        blackView.alpha = 0

        containerView.frame = CGRect(x: 0,
                                     y: window.frame.height,
                                     width: window.frame.width,
                                     height: height + 50) // extra 50 padding for swipe up gesture

        initializePages(window: window)
        isFirstOpen = false
    }

    func addToSuperView(window: UIWindow) {
        window.addSubview(blackView)
        window.addSubview(containerView)
        print(window.subviews.count)
    }

    func removeFromWindow() {
        blackView.removeFromSuperview()
        containerView.removeFromSuperview()
    }

    func initializePages(window: UIWindow) {
        // Initialize additional required views
        let swipeIndicator: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            view.layer.cornerRadius = 3
            return view
        }()

        let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            return stackView
        }()

        // Add subviews to page containerView
        let subviews = [swipeIndicator, scrollView]
        subviews.forEach({containerView.addSubview($0)})
        scrollView.addSubview(stackView)

        // Adds pages to stack view
        let arrangedSubviews = [page1, page2]
        arrangedSubviews.forEach({stackView.addArrangedSubview($0)})

        // Handle constraints
        swipeIndicator.centerHorizontallyInSuperview()
        swipeIndicator.anchor(top: containerView.topAnchor,
                              padding: .init(top: 10, left: 0, bottom: 0, right: 5),
                              size: .init(width: 50, height: 6))

        scrollView.anchor(top: swipeIndicator.bottomAnchor,
                          leading: containerView.leadingAnchor,
                          bottom: containerView.bottomAnchor,
                          trailing: containerView.trailingAnchor)

        stackView.anchor(top: scrollView.topAnchor,
                         leading: scrollView.leadingAnchor,
                         bottom: scrollView.bottomAnchor,
                         trailing: scrollView.trailingAnchor)

        page1.anchor(size: .init(width: window.frame.width, height: 434))
        page2.anchor(size: .init(width: window.frame.width, height: 434))
    }

    func setupViews() {
        // Adds dismissing gestures
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        containerView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(swipeDown)))

        switch isOnboarding {
        case true:
            setupPage1Onboarding()
        case false:
            setupPage1()
        }
        setupPage2()
    }

    func setupPage1() {
        // Initialize additional required views
        page1TitleLabel.text = "Select a drink"

        let buttonsContainer: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor(named: "infoPanelDark")
            view.layer.cornerRadius = 5
            return view
        }()

        // Add subviews to page 1
        let subViews = [page1TitleLabel, buttonsContainer, collectionView, pageControl]
        subViews.forEach({page1.addSubview($0)})
        buttonsContainer.addSubview(horizontalSV)

        // Handle constraints
        page1TitleLabel.centerHorizontallyInSuperview()
        page1TitleLabel.anchor(top: page1.topAnchor,
                               padding: .init(top: 5, left: 0, bottom: 0, right: 0),
                               size: .init(width: 0, height: 25))

        buttonsContainer.anchor(top: page1TitleLabel.bottomAnchor,
                                leading: page1.leadingAnchor,
                                trailing: page1.trailingAnchor,
                                padding: .init(top: 10, left: 10, bottom: 0, right: 10),
                                size: .init(width: 0, height: 100))

        horizontalSV.anchor(leading: buttonsContainer.leadingAnchor,
                            trailing: buttonsContainer.trailingAnchor,
                            size: .init(width: buttonsContainer.frame.width, height: 80))
        horizontalSV.centerVerticallyInSuperview()

        collectionView.anchor(top: buttonsContainer.bottomAnchor,
                              leading: page1.leadingAnchor,
                              trailing: page1.trailingAnchor,
                              padding: .init(top: 5, left: 10, bottom: 0, right: 10),
                              size: .init(width: 0, height: 260))

        pageControl.anchor(top: collectionView.bottomAnchor)
        pageControl.centerHorizontallyInSuperview()
    }

    func setupPage1Onboarding() {
        // Initialize additional required views
        page1TitleLabel.text = "Choose a Favourite"

        // Add subviews to page 1
        let subViews = [page1TitleLabel, collectionView, pageControl]
        subViews.forEach({page1.addSubview($0)})

        // Handle constraints
        page1TitleLabel.centerHorizontallyInSuperview()
        page1TitleLabel.anchor(top: page1.topAnchor,
                               padding: .init(top: 5, left: 0, bottom: 0, right: 0),
                               size: .init(width: 0, height: 25))

        collectionView.anchor(top: page1TitleLabel.bottomAnchor,
                              leading: page1.leadingAnchor,
                              trailing: page1.trailingAnchor,
                              padding: .init(top: 0, left: 10, bottom: 0, right: 10),
                              size: .init(width: 0, height: 360))

        pageControl.anchor(top: collectionView.bottomAnchor)
        pageControl.centerHorizontallyInSuperview()
    }

    // swiftlint:disable:next function_body_length
    func setupPage2() {
        // Initialize additional required views
        let page2TitleLabel: UILabel = {
            let label = UILabel()
            label.text = "Choose Volume"
            label.textColor = UIColor.white
            label.font = UIFont.boldSystemFont(ofSize: 19.0)
            return label
        }()

        let backButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
            button.tintColor = .whiteText
            button.contentVerticalAlignment = .fill
            button.contentHorizontalAlignment = .fill
            button.imageView?.contentMode = .scaleAspectFit
            button.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
            return button
        }()

        let imageContainerView: UIImageView = {
            let imageView = UIImageView()
            imageView.backgroundColor = UIColor(named: "infoPanelDark")
            imageView.layer.cornerRadius = 10
            return imageView
        }()

        let addDrinkButton: UIButton = {
            let button = UIButton()
            button.setTitle("Add drink", for: .normal)
            button.backgroundColor = UIColor(named: "infoPanelDark")
            button.layer.cornerRadius = 10
            button.addTarget(self, action: #selector(addDrinkAction), for: .touchUpInside)
            return button
        }()

        // Add subviews to page 2
        let subViews = [page2TitleLabel, backButton, imageContainerView, drinkNameLabel, picker,
                        addDrinkButton]
        subViews.forEach({page2.addSubview($0)})
        imageContainerView.addSubview(detailImageView)

        // Handle constraints
        page2TitleLabel.anchor(top: page2.topAnchor,
                               padding: .init(top: 5, left: 0, bottom: 0, right: 0),
                               size: .init(width: 0, height: 25))
        page2TitleLabel.centerHorizontallyInSuperview()

        backButton.anchor(top: page2.topAnchor,
                          leading: page2.leadingAnchor,
                          padding:.init(top: 5, left: 10, bottom: 0, right: 0),
                          size: .init(width: 25, height: 25))

        imageContainerView.anchor(top: page2TitleLabel.bottomAnchor,
                                  padding: .init(top: 10, left: 0, bottom: 0, right: 0),
                                  size: .init(width: 140, height: 140))
        imageContainerView.centerHorizontallyInSuperview()

        detailImageView.anchor(top: imageContainerView.topAnchor,
                               leading: imageContainerView.leadingAnchor,
                               bottom: imageContainerView.bottomAnchor,
                               trailing: imageContainerView.trailingAnchor,
                               padding: .init(top: 20, left: 20, bottom: 20, right: 20))
        detailImageView.image = UIImage(named: "coffee.svg")

        drinkNameLabel.anchor(top: imageContainerView.bottomAnchor,
                              padding: .zero,
                              size: .init(width: 0, height: 25))
        drinkNameLabel.centerHorizontallyInSuperview()

        picker.anchor(top: drinkNameLabel.bottomAnchor,
                      leading: page2.leadingAnchor,
                      trailing: page2.trailingAnchor,
                      size: .init(width: 0, height: 120))

        addDrinkButton.anchor(top: picker.bottomAnchor,
                              leading: page2.leadingAnchor,
                              trailing: page2.trailingAnchor,
                              padding: .init(top: 20, left: 10, bottom: 0, right: 10),
                              size: .init(width: 0, height: 50))

        picker.selectRow(5, inComponent: 0, animated: false)
    }

    func setupStackView() {
        let spacer1 = UIView(), spacer2 = UIView(), spacer3 = UIView(), spacer4 = UIView(), spacer5 = UIView()

        let arrangedSubviews = [spacer1, contentView1, spacer2, contentView2, spacer3, contentView3, spacer4,
                                contentView4, spacer5]
        arrangedSubviews.forEach({horizontalSV.addArrangedSubview($0)})

        // Sets all spacer views to have equal width
        let views = [spacer2, spacer3, spacer4, spacer5]
        views.forEach({spacer1.setEqualWidthTo($0)})

        let quickDrink1Tapped = UITapGestureRecognizer(target: self, action: #selector(self.quickDrink1Tap(_:)))
        contentView1.addGestureRecognizer(quickDrink1Tapped)

        let quickDrink2Tapped = UITapGestureRecognizer(target: self, action: #selector(self.quickDrink2Tap(_:)))
        contentView2.addGestureRecognizer(quickDrink2Tapped)

        let quickDrink3Tapped = UITapGestureRecognizer(target: self, action: #selector(self.quickDrink3Tap(_:)))
        contentView3.addGestureRecognizer(quickDrink3Tapped)

        let quickDrink4Tapped = UITapGestureRecognizer(target: self, action: #selector(self.quickDrink4Tap(_:)))
        contentView4.addGestureRecognizer(quickDrink4Tapped)
    }

    // MARK: - Other UI Methods -
    func setBeverageForDetailView(beverage: Beverage) {
        currentBeverage = beverage
        drinkNameLabel.text = beverage.name
        detailImageView.image = UIImage(named: beverage.imageName)

    }

    func reloadQuickDrinks() {
        contentView1.titleLabel.text = "\(Int(userDefaults.favDrink1Volume))ml"
        contentView1.imageView.image = UIImage(named: userDefaults.favBeverage1.imageName)

        contentView2.titleLabel.text = "\(Int(userDefaults.favDrink2Volume))ml"
        contentView2.imageView.image = UIImage(named: userDefaults.favBeverage2.imageName)

        contentView3.titleLabel.text = "\(Int(userDefaults.favDrink3Volume))ml"
        contentView3.imageView.image = UIImage(named: userDefaults.favBeverage3.imageName)

        contentView4.titleLabel.text = "\(Int(userDefaults.favDrink4Volume))ml"
        contentView4.imageView.image = UIImage(named: userDefaults.favBeverage4.imageName)
    }

    @objc func handleDismiss() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1, options: .curveEaseOut, animations: {
        self.blackView.alpha = 0

                        if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
                            self.containerView.frame = CGRect(x: 0, y: window.frame.height,
                                                               width: self.containerView.frame.width,
                                                               height: self.containerView.frame.height)
                            // can put in completion handler
                            self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
                        }
                       }, completion: { _ in
                        self.currentVolume = 300
                        self.picker.selectRow(5, inComponent: 0, animated: false)
                       })

    }

    // MARK: - User Interaction -

    @objc func backButtonAction(sender: UIButton!) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }

    @objc func addDrinkAction(sender: UIButton!) {
        handleDismiss()
        delegate?.didAddDrink(beverage: currentBeverage,
                              volume: currentVolume)
    }

    @objc func swipeDown(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            viewTranslation = sender.translation(in: containerView)
            if viewTranslation.y > -50 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7,
                               initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.containerView.frame.origin = CGPoint(x: 0, y: self.origin.y + self.viewTranslation.y)
                })

            }
        case .ended:
            if viewTranslation.y < 100 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7,
                               initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        self.containerView.frame.origin = self.origin
                    })
            } else {
                handleDismiss()
            }
        default:
                break
            }
    }

    @objc func quickDrink1Tap(_ sender: UITapGestureRecognizer? = nil) {
        delegate?.didAddDrink(beverage: userDefaults.favBeverage1,
                              volume: userDefaults.favDrink1Volume)
        handleDismiss()
    }

    @objc func quickDrink2Tap(_ sender: UITapGestureRecognizer? = nil) {
        delegate?.didAddDrink(beverage: userDefaults.favBeverage2,
                              volume: userDefaults.favDrink2Volume)
        handleDismiss()
    }

    @objc func quickDrink3Tap(_ sender: UITapGestureRecognizer? = nil) {
        delegate?.didAddDrink(beverage: userDefaults.favBeverage3,
                              volume: userDefaults.favDrink3Volume)
        handleDismiss()
    }

    @objc func quickDrink4Tap(_ sender: UITapGestureRecognizer? = nil) {
        delegate?.didAddDrink(beverage: userDefaults.favBeverage4,
                              volume: userDefaults.favDrink4Volume)
        handleDismiss()
    }
}

// MARK: - Collection View Deleagate & DataSource -
extension DrinksLauncher: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = beverages.count
        pageControl.numberOfPages = isOnboarding ? Int(ceil(Double(count)/9)) : Int(ceil(Double(count)/6))
        return count
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        setBeverageForDetailView(beverage: beverages[indexPath.item])

        if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
            scrollView.setContentOffset(CGPoint(x: window.frame.width, y: 0), animated: true)
            }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        var cell = UICollectionViewCell()

        if let drinkCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId,
                                                              for: indexPath) as? DrinksCell {
            drinkCell.nameLabel.text = beverages[indexPath.item].name
            drinkCell.imageView.image = UIImage(named: beverages[indexPath.item].imageName)

           cell = drinkCell
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch isOnboarding {
        case true:
            return CGSize(width: collectionView.bounds.width/3, height: collectionView.bounds.height/3)
        case false:
            return CGSize(width: collectionView.bounds.width/3, height: collectionView.bounds.height/2)
        }

    }
}

// MARK: - Picker View Deleagate & DataSource -
extension DrinksLauncher: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return drinkVolumeArray.count
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        40
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int,
                    forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: drinkVolumeArray[row],
                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var volumeString = drinkVolumeArray[row]
        volumeString.removeLast(2)
        let volume: Double = (volumeString as NSString).doubleValue
        currentVolume = volume
    }
    // swiftlint:disable:next file_length
}
