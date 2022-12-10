import UIKit
import RxSwift

protocol HomeViewControllerDelegate: AnyObject {
    func didtapMenuButtom()
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var header: UILabel!
    
    
    
    weak var delegate: HomeViewControllerDelegate?
    let viewmodel = TaskViewModel()
    var listMyTask = [UserTarea]()
    @IBOutlet weak var gestureView: UIView!
    @IBOutlet weak var countMyTask: UILabel!
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscriptions()
        setup()
        title = "Home"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .done, target: self, action: #selector(didtapMenuButtom))
        setupHeader()
        viewmodel.getTaskForUserLoged()
    }
    
    @objc func didtapMenuButtom(){
        delegate?.didtapMenuButtom()
        print("Hola fuimos presionados en el navbar")
    }
}

//MARK: - Subscriptions
extension HomeViewController {
    private func subscriptions(){
        fetchMyTaskSubscription()
    }
    
    private func fetchMyTaskSubscription(){
        viewmodel.myTask.subscribe(onNext: { [weak self] response in
            guard let self = self else { return }
            self.listMyTask = response.filter({ usertarea in
                Int(usertarea.estadoTarea!) != 5
            })
            self.countMyTask.text = String(self.listMyTask.count)
        }).disposed(by: disposeBag)
    }
}

//MARK: - Private
extension HomeViewController {
    private func setup(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        gestureView.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil){
//        let vc = ListTaskViewController()
        let vc = TaskListViewController()
//        vc.datasource = self.listMyTask
        addChild(vc)
        view.addSubview(vc.view)
        vc.view.frame = view.frame
        vc.didMove(toParent: self)
        title = "Mis Tareas"
    }
 
    private func setupHeader(){
        guard let user = UserContextManager.shared.user?.user else { return }
        
        header.text = "\(user.name ?? "") \(user.lastName ?? "") | \(user.cargo?.cargoName ?? "") | \(user.unidad?.unidadName ?? "")"
    }
    
}
