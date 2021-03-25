protocol PersistentDataViewProtocol: class {
    var coreDataController: CoreDataControllerProtocol! { get set }
    var userDefaultsController: UserDefaultsControllerProtocol! { get set }
}
