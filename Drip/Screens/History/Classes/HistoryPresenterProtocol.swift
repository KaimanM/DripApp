protocol HistoryPresenterProtocol: class {
    var view: HistoryViewProtocol? { get }

    func onViewDidLoad()
    func onViewWillAppear()
    func onViewDidAppear()

    func numberOfRowsInSection() -> Int
    func cellForRowAt(cell: DrinkTableViewCell, row: Int) -> DrinkTableViewCell
}
