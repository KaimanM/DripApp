import Foundation

final class OnboardingPagesPresenter: OnboardingPagesPresenterProtocol {
    weak private(set) var view: OnboardingPagesViewProtocol?

    init(view: OnboardingPagesViewProtocol) {
        self.view = view
    }

    func onViewDidAppear() {
    }

    func onViewDidLoad() {
    }

    func onViewWillAppear() {
    }

    func onViewWillDisappear() {
    }
}
