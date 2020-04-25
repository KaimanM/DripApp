import UIKit

final class WelcomeView: UIViewController, WelcomeViewProtocol {
    var presenter: WelcomePresenterProtocol!
    
    @IBOutlet weak var primaryButton: UIButton!
    @IBOutlet weak var bodyLabel: UILabel!
    
    override func viewDidLoad() {
        presenter.onViewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presenter.onViewDidAppear()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidLoad()
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
