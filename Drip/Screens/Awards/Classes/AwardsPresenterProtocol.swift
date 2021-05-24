protocol AwardsPresenterProtocol: AnyObject {
    var view: AwardsViewProtocol? { get }

    func onViewDidAppear()
    func onViewDidLoad()

    func cellForRowAt(index: Int) -> (title: String, imageName: String)
    func didSelectItemAt(index: Int)
    func numberOfItemsInSection() -> Int
}
