class WhatsNewPresenter: WhatsNewPresenterProtocol {
    var view: WhatsNewViewProtocol?

    init(view: WhatsNewViewProtocol) {
        self.view = view
    }

    func numberOfRowsInSection() -> Int {
        if let view = view {
            return view.featureItems.count
        } else {
            return 0
        }
    }

    func cellForRowAt(row: Int) -> WhatsNewItem? {
        guard let view = view,
              !view.featureItems.isEmpty else {
            return nil
        }
        return view.featureItems[row]
    }
}
