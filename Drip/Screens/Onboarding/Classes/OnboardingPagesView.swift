import UIKit

final class OnboardingPagesView: UIViewController, OnboardingPagesViewProtocol {
    var presenter: OnboardingPagesPresenterProtocol!
    var userDefaultsController: UserDefaultsControllerProtocol!
    var notificationController: LocalNotificationControllerProtocol!

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        return collectionView
    }()

    let page1CellId = "page1"
    let page2CellId = "page2"
    let page3CellId = "page3"
    let page4CellId = "page4"

    lazy var drinksLauncher = DrinksLauncher(userDefaults: userDefaultsController, isOnboarding: true)

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        drinksLauncher.delegate = self
        view.backgroundColor = .black
        setupSubviews()
        collectionView.register(OnboardingPage1Cell.self, forCellWithReuseIdentifier: page1CellId)
        collectionView.register(OnboardingPage2Cell.self, forCellWithReuseIdentifier: page2CellId)
        collectionView.register(OnboardingPage3Cell.self, forCellWithReuseIdentifier: page3CellId)
        collectionView.register(OnboardingPage4Cell.self, forCellWithReuseIdentifier: page4CellId)
    }

    override func viewWillDisappear(_ animated: Bool) {
        drinksLauncher.removeFromWindow()
        super.viewWillDisappear(animated)
    }

    func setupSubviews() {
        view.addSubview(collectionView)
        collectionView.fillSuperViewSafely()
    }

    func setToggleStatus(isOn: Bool) {
        let indexPath = IndexPath(item: 3, section: 0)
        DispatchQueue.main.async {
            if let cell = self.collectionView.cellForItem(at: indexPath) as? OnboardingPage4Cell {
                cell.toggle.isOn = isOn
                print("setting toggle \(isOn)")
            }
        }
    }

    func showSettingsNotificationDialogue() {
        DispatchQueue.main.async {
            let message = "Please enable notifications in System Settings if you want to receive reminders."
            let alertContoller = UIAlertController(title: "Enable Notifications",
                                                   message: message,
                                                   preferredStyle: .alert)

            let settingsAction = UIAlertAction(title: "Open Settings", style: .default) { _ in
                if let bundleIdentifier = Bundle.main.bundleIdentifier, let appSettings =
                    URL(string: UIApplication.openSettingsURLString + bundleIdentifier) {
                    if UIApplication.shared.canOpenURL(appSettings) {
                        UIApplication.shared.open(appSettings)
                    }
                }
            }

            let cancelAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)

            alertContoller.addAction(cancelAction)
            alertContoller.addAction(settingsAction)

            self.present(alertContoller, animated: true)
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

extension OnboardingPagesView: UICollectionViewDelegate, UICollectionViewDataSource,
                               UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = 4
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
        case 3:
            if let page4cell = collectionView.dequeueReusableCell(withReuseIdentifier: page4CellId,
                                                                  for: indexPath) as? OnboardingPage4Cell {
                page4cell.delegate = self
                cell = page4cell
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
    func invalidName() {
        let message = "Names must be less than 15 characters in length."
        let alertController = UIAlertController(title: "Invalid Name",
                                                message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default)
        alertController.addAction(dismissAction)
        present(alertController, animated: true)
    }

    func didTapPage3Button(name: String, goal: Double) {
        presenter.setNameAndGoal(name: name, goal: goal)
        let indexPath = IndexPath(item: 3, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)

    }
}

extension OnboardingPagesView: OnboardingPage4CellDelegate {
    func showDrinksForIndex(index: Int) {
        presenter.setSelectedFavourite(selected: index)
        drinksLauncher.showDrinks()
    }

    func drinkForCellAt(index: Int) -> (imageName: String, volume: Double) {
        return presenter.drinkForCellAt(index: index)
    }

    func didTapPage4Button() {
        let tabBarViewController = TabBarScreenBuilder().build()
        tabBarViewController.modalPresentationStyle = .fullScreen
        presenter.didCompleteOnboarding()
        present(tabBarViewController, animated: true, completion: nil)
    }

    func toggleDidChange(enabled: Bool) {
        presenter.onSwitchToggle(isOn: enabled)
    }
}

extension OnboardingPagesView: DrinksLauncherDelegate {
    func didAddDrink(beverage: Beverage, volume: Double) {
        presenter.addFavourite(beverage: beverage, volume: volume)
        if let cell = collectionView.cellForItem(at: IndexPath(item: 3, section: 0)) as? OnboardingPage4Cell {
            cell.collectionView.reloadData()
        }
    }
}
