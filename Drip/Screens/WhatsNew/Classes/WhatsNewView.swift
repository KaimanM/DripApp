import UIKit

class WhatsNewView: UIViewController, WhatsNewViewProtocol {
    var presenter: WhatsNewPresenterProtocol!

    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white

        let attributedText = NSMutableAttributedString.init(string: "What's New?")
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor,
                                    value: UIColor.dripMerged,
                                    range: NSRange(0...5))
        label.attributedText = attributedText

        label.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        return label
    }()

    let dismissButton: UIButton = {
        let button = UIButton()
        button.setTitle("Continue", for: .normal)
        button.backgroundColor = .dripMerged
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(continueBtnTapped), for: .touchUpInside)
        return button
    }()

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
        return tableView
    }()

    var featureItems: [WhatsNewItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .infoPanelBG
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WhatsNewItemCell.self, forCellReuseIdentifier: "cellId")
        setupSubViews()
    }

    func setupSubViews() {
        [titleLabel, dismissButton, tableView].forEach({ view.addSubview($0) })

        titleLabel.anchor(top: view.topAnchor,
                          padding: .init(top: 80, left: 0, bottom: 0, right: 0))
        titleLabel.centerHorizontallyInSuperview()

        dismissButton.anchor(leading: view.leadingAnchor,
                             bottom: view.safeAreaLayoutGuide.bottomAnchor,
                             trailing: view.trailingAnchor,
                             padding: .init(top: 0, left: 20, bottom: 20, right: 20), size: .init(width: 0, height: 50))

        tableView.anchor(top: titleLabel.bottomAnchor,
                         leading: view.leadingAnchor,
                         bottom: dismissButton.topAnchor,
                         trailing: view.trailingAnchor,
                         padding: .init(top: 40, left: 20, bottom: 20, right: 20))

    }

    @objc func continueBtnTapped() {
        dismiss(animated: true)
    }
}

extension WhatsNewView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "cellId") as?
                WhatsNewItemCell else {
            return UITableViewCell()
        }

        if let cellData = presenter.cellForRowAt(row: indexPath.row) {
            cell.featureImage.image = cellData.image
            cell.titleLabel.text = cellData.title
            cell.subtitleLabel.text = cellData.subtitle
        }

        return cell

    }
}
