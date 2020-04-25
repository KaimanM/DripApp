import UIKit

final class WelcomeView: UIViewController, UITableViewDelegate, UITableViewDataSource, WelcomeViewProtocol {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
//        cell.textLabel?.text = "Cell \(indexPath.row)"
//        cell.backgroundColor = .black
//        cell.textLabel?.textColor = .red
//        return cell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExampleCell") as! ExampleCell

        cell.exampleLabel.text = "this is a test number \(indexPath.row)"
        return cell
    }
    
    var presenter: WelcomePresenterProtocol!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        presenter.onViewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.prefersLargeTitles = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .black
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

class ExampleCell: UITableViewCell {
    @IBOutlet weak var exampleLabel: UILabel!
    @IBOutlet weak var exampleImage: UIImageView!
    
    override func awakeFromNib() {
        backgroundColor = .black
        exampleLabel.textColor = .green
    }
}
