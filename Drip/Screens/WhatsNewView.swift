import UIKit

struct WhatsNewItem {
    let title: String
    let subtitle: String
    let image: UIImage
}

class WhatsNewController: UIViewController {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "What's New?"
        label.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        label.textColor = .white
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
        view.addSubview(titleLabel)
        view.addSubview(dismissButton)
        view.addSubview(tableView)
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

extension WhatsNewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return featureItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "cellId") as?
                WhatsNewItemCell else {
            return UITableViewCell()
        }

        cell.featureImage.image = featureItems[indexPath.row].image
        cell.titleLabel.text = featureItems[indexPath.row].title
        cell.subtitleLabel.text = featureItems[indexPath.row].subtitle
        cell.alpha = 0
        return cell

    }
}

class WhatsNewItemCell: UITableViewCell {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Test"
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .whiteText
        return label
    }()

    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Test \nTest \nTest \nTest \nTest"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .whiteText
        return label
    }()

    let featureImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "star")
        imageView.tintColor = .dripMerged
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(featureImage)
        backgroundColor = .clear

        featureImage.anchor(leading: contentView.leadingAnchor,
                            padding: .init(top: 10, left: 20, bottom: 10, right: 0),
                            size: .init(width: 50, height: 50))
        featureImage.centerVerticallyInSuperview()

        titleLabel.anchor(top: contentView.topAnchor,
                          leading: featureImage.trailingAnchor,
                          trailing: contentView.trailingAnchor,
                          padding: .init(top: 10, left: 15, bottom: 0, right: 20))

        subtitleLabel.anchor(top: titleLabel.bottomAnchor,
                             leading: titleLabel.leadingAnchor,
                             bottom: contentView.bottomAnchor,
                             trailing: titleLabel.trailingAnchor,
                             padding: .init(top: 0, left: 0, bottom: 10, right: 0))


    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
