import UIKit
import RxSwift

protocol HomeViewControllerDelegate: AnyObject {
    func didtapMenuButtom()
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var header: UILabel!
    
    @IBOutlet weak var countFlows: UILabel!
    
    @IBOutlet weak var containerFlow: UIView!
    
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
        viewmodel.getFlowByMyUser()
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
        fetchMyFlowsSubscriptions()
    }
    
    private func fetchMyTaskSubscription(){
        viewmodel.myTask.subscribe(onNext: { [weak self] response in
            guard let self = self else { return }
            self.listMyTask = response.filter({ usertarea in
                Int(usertarea.estadoTarea!) != 5
            })
            self.countMyTask.text = String(self.listMyTask.filter({ tarea in
                Int(tarea.estadoTarea!) != 3 &&  Int(tarea.estadoTarea!) != 5
            }).count)
        }).disposed(by: disposeBag)
    }
    
    private func fetchMyFlowsSubscriptions(){
        viewmodel.myFlow.subscribe(onNext: { [weak self] flujo in
            self?.countFlows.text = String(flujo.count)
        }).disposed(by: disposeBag)
        
    }
}

//MARK: - Private
extension HomeViewController {
    private func setup(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        gestureView.addGestureRecognizer(tap)
        
        
        let tapFlow = UITapGestureRecognizer(target: self, action: #selector(self.handleTapFlow(_:)))
        containerFlow.addGestureRecognizer(tapFlow)
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
    
    @objc func handleTapFlow(_ sender: UITapGestureRecognizer? = nil){
        let vc = UserFlujoViewController()
        addChild(vc)
        view.addSubview(vc.view)
        vc.view.frame = view.frame
        vc.didMove(toParent: self)
        title = "Mis Flujos"
    }
 
 
    private func setupHeader(){
        guard let user = UserContextManager.shared.user?.user else { return }
        
        header.text = "\(user.name ?? "") \(user.lastName ?? "") | \(user.cargo?.cargoName ?? "") | \(user.unidad?.unidadName ?? "")"
    }
    
}
