import UIKit

protocol DrinksLauncherDelegate: class {
    func drinkForItemAt(indexPath: IndexPath) -> (name: String, imageName: String)
    func numberOfItemsInSection() -> Int
    func didSelectItemAt(indexPath: IndexPath)
    func getQuickDrinkAt(index: Int) -> (name: String, imageName: String)
    func didTapQuickDrinkAt(index: Int)
    func didAddDrink(name: String, imageName: String, volume: Double)
}

class DrinksLauncher: NSObject {

    weak var delegate: DrinksLauncherDelegate?

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

    let picker = UIPickerView()

    let contentView1 = QuickDrinkView()
    let contentView2 = QuickDrinkView()
    let contentView3 = QuickDrinkView()
    let contentView4 = QuickDrinkView()

    let pageControl = UIPageControl()

    let cellId = "cellId"

    var origin = CGPoint(x: 0, y: 0)
    var viewTranslation = CGPoint(x: 0, y: 0)

    let drinkNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Water"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()

    let detailImageView = UIImageView() // needs to be moved outside func

    let drinkVolumeArray = ["50ml", "100ml", "150ml", "200ml", "250ml", "300ml", "350ml", "400ml",
                            "450ml", "500ml", "550ml", "600ml", "650ml", "700ml", "750ml", "800ml",
                            "850ml", "900ml", "1000ml"]

    var currentVolume: Double = 300
    var currentDrinkName = "Water"
    var currentDrinkImageName = "waterbottle.svg"
    var isFirstOpen = true

    func showDrinks() {
        reloadQuickDrinks()

        if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
            let height: CGFloat = 460
            let yOffset = window.frame.height - height

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

    func firstTimeOpenConstraints(window: UIWindow, height: CGFloat) {
        window.addSubview(blackView)
        window.addSubview(containerView)

        blackView.frame = window.frame
        blackView.alpha = 0

        containerView.frame = CGRect(x: 0,
                                     y: window.frame.height,
                                     width: window.frame.width,
                                     height: height + 50) // extra 50 padding for swipe up gesture

        initializePages(window: window)
        isFirstOpen = false
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

        setupPage1()
        setupPage2()
    }

    func setupPage1() {
        // Initialize additional required views
        let page1TitleLabel: UILabel = {
            let label = UILabel()
            label.text = "Select a drink"
            label.textColor = UIColor.white
            label.font = UIFont.boldSystemFont(ofSize: 19.0)
            return label
        }()

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

    @objc func backButtonAction(sender: UIButton!) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }

    @objc func addDrinkAction(sender: UIButton!) {
        handleDismiss()
        delegate?.didAddDrink(name: currentDrinkName,
                              imageName: currentDrinkImageName,
                              volume: currentVolume)
    }

    func setImageAndTitleForDetailView(name: String, imageName: String) {
        currentDrinkName = name
        currentDrinkImageName = imageName
        drinkNameLabel.text = currentDrinkName
        detailImageView.image = UIImage(named: currentDrinkImageName)

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

    func reloadQuickDrinks() {
        let quickDrinkViews = [contentView1, contentView2, contentView3, contentView4]
        for (index, view) in quickDrinkViews.enumerated() {
            if let data = delegate?.getQuickDrinkAt(index: index) {
                view.titleLabel.text = data.name
                view.imageView.image = UIImage(named: data.imageName)
            }
        }
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
        })

    }

    @objc func quickDrink1Tap(_ sender: UITapGestureRecognizer? = nil) {
        delegate?.didTapQuickDrinkAt(index: 0)
    }

    @objc func quickDrink2Tap(_ sender: UITapGestureRecognizer? = nil) {
        delegate?.didTapQuickDrinkAt(index: 1)
    }

    @objc func quickDrink3Tap(_ sender: UITapGestureRecognizer? = nil) {
        delegate?.didTapQuickDrinkAt(index: 2)
    }

    @objc func quickDrink4Tap(_ sender: UITapGestureRecognizer? = nil) {
        delegate?.didTapQuickDrinkAt(index: 3)
    }

    override init() {
        super.init()
        // do stuff
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

}

extension DrinksLauncher: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = delegate?.numberOfItemsInSection() else { return 0 }
        pageControl.numberOfPages = Int(ceil(Double(count)/6))
        return count
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear, animations: {
//            self.blackView.alpha = 0
//
//            if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
//                self.containerview.frame = CGRect(x: 0, y: window.frame.height,
//                                                   width: self.containerview.frame.width,
//                                                   height: self.containerview.frame.height)
//            }
//        }, completion: {_ in
//            self.delegate?.didSelectItemAt(indexPath: indexPath)
//        })
        if let cellData = delegate?.drinkForItemAt(indexPath: indexPath) {
            setImageAndTitleForDetailView(name: cellData.name, imageName: cellData.imageName)
        }

        if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
            scrollView.setContentOffset(CGPoint(x: window.frame.width, y: 0), animated: true)
            }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        var cell = UICollectionViewCell()

        if let drinkCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId,
                                                              for: indexPath) as? DrinksCell,
           let cellData = delegate?.drinkForItemAt(indexPath: indexPath) {

            drinkCell.nameLabel.text = cellData.name
            drinkCell.imageView.image = UIImage(named: cellData.imageName)

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
        return CGSize(width: collectionView.bounds.width/3, height: collectionView.bounds.height/2)
    }
}

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
        print("cur vol is \(currentVolume)")
    }
}
