protocol PersistentDataViewProtocol: AnyObject {
    var coreDataController: CoreDataControllerProtocol! { get set }
    var userDefaultsController: UserDefaultsControllerProtocol! { get set }
}
