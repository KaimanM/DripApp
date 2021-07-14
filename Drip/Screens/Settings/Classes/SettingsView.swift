import UIKit
import SafariServices
import StoreKit

final class SettingsView: UIViewController, SettingsViewProtocol, PersistentDataViewProtocol,
                          HealthKitViewProtocol {

    var presenter: SettingsPresenterProtocol!
    var coreDataController: CoreDataControllerProtocol!
    var userDefaultsController: UserDefaultsControllerProtocol!
    var healthKitController: HealthKitControllerProtocol!

    let tableView = UITableView(frame: .zero, style: .grouped)

    let cellId = "settingsCell"

    override func viewDidLoad() {
        presenter.onViewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.prefersLargeTitles = true

        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(SettingsCell.self, forCellReuseIdentifier: cellId)
        tableView.backgroundColor = .black
        view.addSubview(tableView)
        tableView.fillSuperView()

        tableView.separatorColor = UIColor.white.withAlphaComponent(0.2)
    }

    override func viewDidAppear(_ animated: Bool) {
        presenter.onViewDidAppear()
        navigationItem.backBarButtonItem = nil
    }

    func presentView(_ view: UIViewController) {
        present(view, animated: true)
    }

    func showView(_ view: UIViewController) {
        show(view, sender: self)
    }

    func pushView(_ view: UIViewController) {
        self.navigationController?.pushViewController(view, animated: true)
    }

    func updateTitle(title: String) {
        self.title = title
    }

    func showReviewPrompt() {
        guard let reviewUrl = URL(string: "https://apps.apple.com/app/id1563574862?action=write-review") else { return }
        UIApplication.shared.open(reviewUrl, options: [:], completionHandler: nil)
    }

    func showWhatsNew() {
        WhatsNewController().showWhatsNew(view: self)
    }

    func showSafariWith(url: URL) {
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        let safariVC = SFSafariViewController(url: url, configuration: config)
        safariVC.preferredBarTintColor = .black
        safariVC.preferredControlTintColor = .whiteText
        safariVC.modalPresentationStyle = .popover
        self.navigationController?.present(safariVC, animated: true, completion: nil)
    }

    func changeNameTapped() {
        let name = presenter.fetchName()
        let message = "We're currently calling you \"\(name)\". What should we call you instead?"
        let alertContoller = UIAlertController(title: "Change Name",
                                               message: message,
                                               preferredStyle: .alert)

        alertContoller.addTextField()
        alertContoller.textFields![0].keyboardType = UIKeyboardType.alphabet

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned alertContoller] _ in
            self.presenter.updateName(name: alertContoller.textFields![0].text)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertContoller.addAction(cancelAction)
        alertContoller.addAction(submitAction)

        present(alertContoller, animated: true)
    }

    func invalidName() {
        let message = "Names can not be empty, and must be less than 15 characters in length."
        let alertController = UIAlertController(title: "Invalid Name",
                                                message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default)
        alertController.addAction(dismissAction)
        present(alertController, animated: true)
    }

    func setupHeaderView() -> UIView {
        let contentView = UIView()
        let containerView = UIView()

        let imageView = UIImageView()
        imageView.image = Bundle.main.icon
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true

        let appNameLabel = UILabel()
        appNameLabel.text = "Drip \(Bundle.main.appVersion)"
        appNameLabel.font = UIFont.boldSystemFont(ofSize: 15)
        appNameLabel.textColor = .whiteText

        let devNameLabel = UILabel()
        devNameLabel.text = "by Kaiman Mehmet"
        devNameLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        devNameLabel.textColor = .lightGray

        containerView.addSubview(imageView)
        containerView.addSubview(appNameLabel)
        containerView.addSubview(devNameLabel)

        imageView.anchor(top: containerView.topAnchor,
                         leading: containerView.leadingAnchor,
                         bottom: containerView.bottomAnchor,
                         size: .init(width: 80, height: 80))

        appNameLabel.anchor(top: containerView.topAnchor,
                            leading: imageView.trailingAnchor,
                            trailing: containerView.trailingAnchor,
                            padding: .init(top: 20, left: 10, bottom: 0, right: 10))

        devNameLabel.anchor(leading: imageView.trailingAnchor,
                            bottom: containerView.bottomAnchor,
                            trailing: containerView.trailingAnchor,
                            padding: .init(top: 0, left: 10, bottom: 20, right: 10))

        contentView.addSubview(containerView)
        containerView.centerInSuperview()

        return contentView
    }
}

extension SettingsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection(section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: cellId) as? SettingsCell else {
            return UITableViewCell()
        }

        let cellData = presenter.getCellDataForIndexPath(indexPath: indexPath)
        cell.textLabel?.text = cellData.title
        cell.iconImageView.image = UIImage(systemName: cellData.imageName)
        cell.imageContainerView.backgroundColor = cellData.backgroundColour
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 120
        }
        return 20
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view = UIView()
        view.isUserInteractionEnabled = false
        if section == 0 {
            view = setupHeaderView()
        }
        return view
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRowAt(indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

struct SettingsCellData {
    let title: String
    let imageName: String
    let backgroundColour: UIColor
}
