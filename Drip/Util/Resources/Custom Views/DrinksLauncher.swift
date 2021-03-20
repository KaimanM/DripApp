import UIKit

class DrinksLauncher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    let blackView = UIView()

    let containerview = UIView()

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        return collectionView
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

    func showDrinks() {
        print("tapped")

        if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {

            // black background view
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))

            containerview.backgroundColor = .purple
            containerview.layer.cornerRadius = 20
            containerview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

            window.addSubview(blackView)
            window.addSubview(containerview)
            print(window.subviews.count)

            containerview.addSubview(titleLabel)
            containerview.addSubview(buttonsContainer)
            containerview.addSubview(collectionView)
            containerview.addSubview(pageControl)

            titleLabel.centerHorizontallyInSuperview()
            titleLabel.anchor(top: containerview.topAnchor,
                              leading: nil, bottom: nil, trailing: nil,
                              padding: .init(top: 10, left: 0, bottom: 0, right: 0))

            buttonsContainer.backgroundColor = .gray
            buttonsContainer.layer.cornerRadius = 5
            buttonsContainer.anchor(top: titleLabel.bottomAnchor,
                                    leading: containerview.leadingAnchor,
                                    bottom: nil,
                                    trailing: containerview.trailingAnchor,
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

            collectionView.anchor(top: buttonsContainer.bottomAnchor,
                                  leading: containerview.leadingAnchor,
                                  bottom: nil,
                                  trailing: containerview.trailingAnchor,
                                  padding: .init(top: 10, left: 10, bottom: 0, right: 10),
                                  size: .init(width: 0, height: 260))
            pageControl.anchor(top: collectionView.bottomAnchor,
                               leading: nil, bottom: nil, trailing: nil, padding: .zero)
            pageControl.centerHorizontallyInSuperview()

            blackView.frame = window.frame
            blackView.alpha = 0

            let height: CGFloat = 450
            let yOffset = window.frame.height - height
            containerview.frame = CGRect(x: 0, y: window.frame.height,
                                          width: window.frame.width,
                                          height: height)

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1,
                           initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.containerview.frame = CGRect(x: 0, y: yOffset,
                                                   width: self.containerview.frame.width,
                                                   height: self.containerview.frame.height)
            }, completion: nil)

        }

    }

    func setupStackView() {

        let spacer1 = UIView()
        let spacer2 = UIView()
        let spacer3 = UIView()
        let spacer4 = UIView()
        let spacer5 = UIView()

        contentView1.imageView.image = UIImage(named: "water.svg")

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
    }

    @objc func handleDismiss() {
        print("dismiss")
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0

            if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
                self.containerview.frame = CGRect(x: 0, y: window.frame.height,
                                                   width: self.containerview.frame.width,
                                                   height: self.containerview.frame.height)
            }
        })

    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = 18
        pageControl.numberOfPages = Int(ceil(Double(count)/6))
        return count
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {

        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DrinksCell
        cell.nameLabel.text = "test\(indexPath.item)"

        let colours: [UIColor] = [.blue, .red, .red, .blue, .blue, .red, .red, .blue, .blue,
                                  .red, .red, .blue, .blue, .red, .red,
                                  .blue, .blue, .red, .red, .blue, .blue]
        cell.backgroundColor = colours[indexPath.item]
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

    override init() {
        super.init()
        // do stuff
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        pageControl.isUserInteractionEnabled = false

        collectionView.register(DrinksCell.self, forCellWithReuseIdentifier: cellId)
        setupStackView()

    }

}

extension UIView {

    func anchor(top: NSLayoutYAxisAnchor?,
                leading: NSLayoutXAxisAnchor?,
                bottom: NSLayoutYAxisAnchor?,
                trailing: NSLayoutXAxisAnchor?,
                padding: UIEdgeInsets = .zero,
                size: CGSize = .zero) {

        translatesAutoresizingMaskIntoConstraints = false

        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }

        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }

        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }

        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }

        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }

        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }

    func centerInSuperview() {
        if let superview = superview {
            centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
            centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
        }
    }

    func centerHorizontallyInSuperview() {
        if let superview = superview {
            centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
        }
    }

    func centerVerticallyInSuperview() {
        if let superview = superview {
            centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
        }
    }

    func fillSuperView() {
        if let superview = superview {
            trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
            topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
            leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
            bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        }
    }
}
