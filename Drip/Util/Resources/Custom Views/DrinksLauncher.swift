import UIKit

protocol DrinksLauncherDelegate: class {
    func drinkForItemAt(indexPath: IndexPath) -> (name: String, imageName: String)
    func numberOfItemsInSection() -> Int
    func didSelectItemAt(indexPath: IndexPath)
    func getQuickDrinkAt(index: Int) -> (name: String, imageName: String)
    func didTapQuickDrinkAt(index: Int)
}

class DrinksLauncher: NSObject {

    weak var delegate: DrinksLauncherDelegate?

    let blackView = UIView()

    let containerview = UIView()

    let page1 = UIView()
    let page2 = UIView()


    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
//        scrollView.backgroundColor = .systemPink
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

    let swipeIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        view.layer.cornerRadius = 3
        return view
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Select a drink"
        label.textColor = UIColor.white
        return label
    }()

    let buttonsContainer = UIView()

    let horizontalSV: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.backgroundColor = .clear
        stackView.distribution = .fill
        stackView.alignment = .fill

        return stackView
    }()

    let contentView1 = QuickDrinkView()
    let contentView2 = QuickDrinkView()
    let contentView3 = QuickDrinkView()
    let contentView4 = QuickDrinkView()

    let pageControl = UIPageControl()

    let cellId = "cellId"

    var origin = CGPoint(x: 0, y: 0)
    var viewTranslation = CGPoint(x: 0, y: 0)

    func showDrinks() {
        print("tapped")
        reloadQuickDrinks()

        if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {

            window.addSubview(blackView)
            window.addSubview(containerview)
            print(window.subviews.count)

            blackView.frame = window.frame
            blackView.alpha = 0

            let height: CGFloat = 460
            let yOffset = window.frame.height - height
            containerview.frame = CGRect(x: 0, y: window.frame.height,
                                          width: window.frame.width,
                                          height: height + 50) // extra 50 padding for swipe up gesture

            setupPages(window: window)

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1,
                           initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.containerview.frame = CGRect(x: 0, y: yOffset,
                                                   width: self.containerview.frame.width,
                                                   height: self.containerview.frame.height)
                           }, completion: {_ in
                            self.origin = self.containerview.frame.origin
                            print("origin is \(self.origin)")
                           })

        }

    }

    func setupPages(window: UIWindow) {
        let subviews = [swipeIndicator, scrollView]
        subviews.forEach({containerview.addSubview($0)})

        swipeIndicator.centerHorizontallyInSuperview()
        swipeIndicator.anchor(top: containerview.topAnchor, leading: nil, bottom: nil, trailing: nil,
                              padding: .init(top: 10, left: 0, bottom: 0, right: 5),
                              size: .init(width: 50, height: 6))

        scrollView.anchor(top: swipeIndicator.bottomAnchor, leading: containerview.leadingAnchor,
                          bottom: containerview.bottomAnchor, trailing: containerview.trailingAnchor)

        scrollView.addSubview(stackView)
        stackView.anchor(top: scrollView.topAnchor, leading: scrollView.leadingAnchor,
                         bottom: scrollView.bottomAnchor, trailing: scrollView.trailingAnchor)

//        page1.backgroundColor = .orange
        stackView.addArrangedSubview(page1)

        page1.anchor(top: nil, leading: nil, bottom: nil, trailing: nil,
                     size: .init(width: window.frame.width, height: 434))

//        page2.backgroundColor = .blue
        stackView.addArrangedSubview(page2)

        page2.anchor(top: nil, leading: nil, bottom: nil, trailing: nil,
                     size: .init(width: window.frame.width, height: 434))
    }

    func setupViews() {
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))

        containerview.backgroundColor = .infoPanelBG
        containerview.layer.cornerRadius = 20
        containerview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        setupPage1()
        setupPage2()

        let swipeDown = UIPanGestureRecognizer(target: self, action: #selector(self.swipeDown))
        containerview.addGestureRecognizer(swipeDown)
    }

    func setupPage1() {
        page1.addSubview(titleLabel)
        page1.addSubview(buttonsContainer)
        page1.addSubview(collectionView)
        page1.addSubview(pageControl)

        titleLabel.centerHorizontallyInSuperview()
        titleLabel.anchor(top: page1.topAnchor,
                          leading: nil, bottom: nil, trailing: nil,
                          padding: .init(top: 5, left: 0, bottom: 0, right: 0))

        buttonsContainer.backgroundColor = UIColor(named: "infoPanelDark")
        buttonsContainer.layer.cornerRadius = 5
        buttonsContainer.anchor(top: titleLabel.bottomAnchor, leading: page1.leadingAnchor,
                                bottom: nil, trailing: page1.trailingAnchor,
                                padding: .init(top: 10, left: 10, bottom: 0, right: 10),
                                size: .init(width: 0, height: 100))

        buttonsContainer.addSubview(horizontalSV)
        horizontalSV.anchor(top: nil,
                            leading: buttonsContainer.leadingAnchor,
                            bottom: nil,
                            trailing: buttonsContainer.trailingAnchor,
                            padding: .zero, size: CGSize(width: buttonsContainer.frame.width,
                                                         height: 80))
        horizontalSV.centerVerticallyInSuperview()

        collectionView.anchor(top: buttonsContainer.bottomAnchor, leading: page1.leadingAnchor,
                              bottom: nil, trailing: page1.trailingAnchor,
                              padding: .init(top: 10, left: 10, bottom: 0, right: 10),
                              size: .init(width: 0, height: 260))
        pageControl.anchor(top: collectionView.bottomAnchor,
                           leading: nil, bottom: nil, trailing: nil, padding: .zero)
        pageControl.centerHorizontallyInSuperview()
    }

    func setupPage2() {
        let page2TitleLabel = UILabel()
        page2TitleLabel.text = "Choose Volume"
        page2TitleLabel.textColor = .white
        page2.addSubview(page2TitleLabel)
        page2TitleLabel.anchor(top: page2.topAnchor,
                               leading: nil, bottom: nil, trailing: nil,
                               padding: .init(top: 5, left: 0, bottom: 0, right: 0))
        page2TitleLabel.centerHorizontallyInSuperview()

        let backButton = UIButton()
        page2.addSubview(backButton)
        backButton.anchor(top: page2.topAnchor, leading: page2.leadingAnchor, bottom: nil, trailing: nil,
                          padding:.init(top: 10, left: 10, bottom: 0, right: 0) , size: .init(width: 25, height: 25))
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.tintColor = .whiteText
        backButton.contentVerticalAlignment = .fill
        backButton.contentHorizontalAlignment = .fill
        backButton.imageView?.contentMode = .scaleAspectFit
        backButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

    }

    @objc func buttonAction(sender: UIButton!) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }

    @objc func swipeDown(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            viewTranslation = sender.translation(in: containerview)
            if viewTranslation.y > -50 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7,
                               initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.containerview.frame.origin = CGPoint(x: 0, y: self.origin.y + self.viewTranslation.y)
                })

            }
        case .ended:
            if viewTranslation.y < 100 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7,
                               initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        self.containerview.frame.origin = self.origin
                    })
            } else {
                handleDismiss()
            }
        default:
                break
            }
    }

    func setupStackView() {

        let spacer1 = UIView()
        let spacer2 = UIView()
        let spacer3 = UIView()
        let spacer4 = UIView()
        let spacer5 = UIView()

        horizontalSV.addArrangedSubview(spacer1)
        horizontalSV.addArrangedSubview(contentView1)
        horizontalSV.addArrangedSubview(spacer2)
        horizontalSV.addArrangedSubview(contentView2)
        horizontalSV.addArrangedSubview(spacer3)
        horizontalSV.addArrangedSubview(contentView3)
        horizontalSV.addArrangedSubview(spacer4)
        horizontalSV.addArrangedSubview(contentView4)
        horizontalSV.addArrangedSubview(spacer5)

        spacer1.translatesAutoresizingMaskIntoConstraints = false
        spacer2.translatesAutoresizingMaskIntoConstraints = false
        spacer3.translatesAutoresizingMaskIntoConstraints = false
        spacer4.translatesAutoresizingMaskIntoConstraints = false
        spacer5.translatesAutoresizingMaskIntoConstraints = false

        spacer1.widthAnchor.constraint(equalTo: spacer2.widthAnchor).isActive = true
        spacer1.widthAnchor.constraint(equalTo: spacer3.widthAnchor).isActive = true
        spacer1.widthAnchor.constraint(equalTo: spacer4.widthAnchor).isActive = true
        spacer1.widthAnchor.constraint(equalTo: spacer5.widthAnchor).isActive = true

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
                            self.containerview.frame = CGRect(x: 0, y: window.frame.height,
                                                               width: self.containerview.frame.width,
                                                               height: self.containerview.frame.height)
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
