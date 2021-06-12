protocol WhatsNewViewProtocol: AnyObject {
    var presenter: WhatsNewPresenterProtocol! { get set }
    var featureItems: [WhatsNewItem] { get }
}
