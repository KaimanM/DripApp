import UIKit

final class OnboardingPagesView: UIViewController, OnboardingPagesViewProtocol {
    var presenter: OnboardingPagesPresenterProtocol!

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .red
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    let page1CellId = "page1"
    let page2CellId = "page2"
    let page3CellId = "page3"

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        view.backgroundColor = .black
        setupSubviews()
        collectionView.register(OnboardingPage1Cell.self, forCellWithReuseIdentifier: page1CellId)
        collectionView.register(OnboardingPage2Cell.self, forCellWithReuseIdentifier: page2CellId)
        collectionView.register(OnboardingPage3Cell.self, forCellWithReuseIdentifier: page3CellId)
    }

    func setupSubviews() {
        view.addSubview(collectionView)
        collectionView.fillSuperViewSafely()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

extension OnboardingPagesView: UICollectionViewDelegate, UICollectionViewDataSource,
                               UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = 3
        return count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        switch indexPath.item {
        case 0:
            if let page1cell = collectionView.dequeueReusableCell(withReuseIdentifier: page1CellId,
                                                                  for: indexPath) as? OnboardingPage1Cell {
                page1cell.delegate = self
                cell = page1cell
            }
        case 1:
            if let page2cell = collectionView.dequeueReusableCell(withReuseIdentifier: page2CellId,
                                                                  for: indexPath) as? OnboardingPage2Cell {
                page2cell.delegate = self
                cell = page2cell
            }
        case 2:
            if let page3cell = collectionView.dequeueReusableCell(withReuseIdentifier: page3CellId,
                                                                  for: indexPath) as? OnboardingPage3Cell {
                page3cell.delegate = self
                cell = page3cell
            }
        default:
            fatalError()
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
        return CGSize(width: collectionView.bounds.width,
                      height: collectionView.bounds.height)
    }

}

extension OnboardingPagesView: OnboardingPage1CellDelegate {
    func didTapPage1Button() {
        let indexPath = IndexPath(item: 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
}

extension OnboardingPagesView: OnboardingPage2CellDelegate {
    func didTapPage2Button() {
        let indexPath = IndexPath(item: 2, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
}

extension OnboardingPagesView: OnboardingPage3CellDelegate {
    func didTapPage3Button(name: String, goal: Double) {
        let userDefaults = UserDefaultsController.shared // TODO: fix this, move dependency later
        userDefaults.drinkGoal = goal
        userDefaults.name = name
        let vc1 = TabBarScreenBuilder().build()
        vc1.modalPresentationStyle = .fullScreen
        present(vc1, animated: true, completion: nil)
    }
}
