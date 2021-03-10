import UIKit

final class TrendsView: UIViewController, TrendsViewProtocol, CoreDataViewProtocol {

    var presenter: TrendsPresenterProtocol!
    var coreDataController: CoreDataControllerProtocol!
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        presenter.onViewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.prefersLargeTitles = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .black
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

    func updateTitle(title: String) {
        self.title = title
    }

}

extension TrendsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let number = section == 0 ? 10 : 6
        return number
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        var cell = UICollectionViewCell()

        if let trendCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                              for: indexPath) as? TrendsCollectionViewCell {
            trendCell.imageView?.image = UIImage(named: "waterbottle.svg")?
                .withTintColor(UIColor.white.withAlphaComponent(0.5))
                .withAlignmentRectInsets(UIEdgeInsets(top: -7,
                                                      left: -7,
                                                      bottom: -7,
                                                      right: -7))
            cell = trendCell
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width: collectionView.frame.width, height: 40)
        }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            var reusableHeaderView = UICollectionReusableView()

            //swiftlint:disable line_length
            if let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                                  withReuseIdentifier: "headerCell", for: indexPath) as? TrendsHeaderView {
            //swiftlint:enable line_length
                reusableview.title.text = indexPath.section == 0 ? "Section 1" : "Section 2"
                reusableHeaderView = reusableview
            }
            return reusableHeaderView
        default:  fatalError("Unexpected element kind")
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let noOfCellsInRow = 2

        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize(width: 50, height: 50)
        }

        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

        return CGSize(width: size, height: 70)
    }
}
