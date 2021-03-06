import UIKit

final class AwardsView: UIViewController, AwardsViewProtocol, PersistentDataViewProtocol {
    var presenter: AwardsPresenterProtocol!
    var coreDataController: CoreDataControllerProtocol!
    var userDefaultsController: UserDefaultsControllerProtocol!

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    let cellId = "awardsCell"

    override func viewDidLoad() {
        presenter.onViewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.prefersLargeTitles = true

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DrinksCell.self, forCellWithReuseIdentifier: cellId)
        view.addSubview(collectionView)
        collectionView.fillSuperView()
        collectionView.contentInset.bottom = 20
    }

    override func viewDidAppear(_ animated: Bool) {
        presenter.onViewDidAppear()
    }

    func presentView(_ view: UIViewController) {
        present(view, animated: true)
    }

    func showView(_ view: UIViewController) {
        show(view, sender: self)
    }

    func pushView(_ view: UIViewController) {
        self.navigationController!.pushViewController(view, animated: true)
    }

    func updateTitle(title: String) {
        self.title = title
    }

    func reloadData() {
        collectionView.reloadData()
    }
}

extension AwardsView: UICollectionViewDelegate, UICollectionViewDataSource,
                               UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfItemsInSection()
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if let awardsCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId,
                                                              for: indexPath) as? DrinksCell {
            let cellData = presenter.cellForRowAt(index: indexPath.item)
            awardsCell.nameLabel.text = cellData.title
            awardsCell.imageView.image = UIImage(named: cellData.imageName)
            awardsCell.imageContainerView.backgroundColor = .clear
            awardsCell.backgroundColor = .black
            cell = awardsCell
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
        return CGSize(width: collectionView.bounds.width/2,
                      height: collectionView.bounds.width/2)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectItemAt(index: indexPath.item)
    }

}
