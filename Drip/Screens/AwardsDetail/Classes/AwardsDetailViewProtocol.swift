import UIKit

protocol AwardsDetailViewProtocol: AnyObject {
    var presenter: AwardsDetailPresenterProtocol! { get set }
    var dataSource: AwardsDetailDataSourceProtocol? { get }
    var timeStamp: Date? { get }

    func updateLabels(awardName: String, awardBody: String, timeStamp: String)
    func updateImage(imageName: String)
}
