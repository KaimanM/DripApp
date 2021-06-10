protocol WhatsNewPresenterProtocol: AnyObject {
    var view: WhatsNewViewProtocol? { get }

    func numberOfRowsInSection() -> Int
    func cellForRowAt(row: Int) -> WhatsNewItem?
}
