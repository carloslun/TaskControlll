
import UIKit
import iOSDropDown
import RxSwift

struct TaskResume {
    let id: Int?
    let title: String
    let state: String
    let time: String
    let fechaTermino: String
    let fechaInicio: String
}

class TaskListViewController: UIViewController {
    var datasource: [UserTarea]? = [] {
        didSet {
            datasource!.sort { userOne, userTwo in
                (userOne.tarea?.fechaInicio!)! < (userTwo.tarea?.fechaInicio!)!
            }
        }
    }
    var indexPath: IndexPath?
    let statusTask = stateContext.shared.options
    var indexState: Int?
    var listMyTask = [UserTarea]()
    let viewmodel = TaskViewModel()
    private var disposeBag = DisposeBag()

    @IBOutlet weak var filterTask: DropDown!
    @IBOutlet weak var taskTableView: UITableView!
    
    let label: UILabel = {
        let label = UILabel.newAutoLayout()
        label.text = "No tienes tareas asignadas"
        label.font = UIFont(name: "", size: 45.0)
        label.textColor = .lightGray
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        subscriptions()
        taskTableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskTableViewCell")
        taskTableView.dataSource = self
        taskTableView.delegate = self
        self.setupFilter()
        viewmodel.getTaskForUserLoged()
    }
    
    func setupFilter(){
        filterTask.isSearchEnable = false
        filterTask.optionArray = statusTask
        filterTask.didSelect { selectedText, index, id in
            self.indexState = index
            if self.listMyTask.count > 0 {
                self.datasource = self.listMyTask.filter({ userTare in
                    Int(userTare.estadoTarea!)  == index
                })
            }
    
            if self.datasource!.count == 0 {
                
                self.taskTableView.addSubview(self.label)
                self.label.autoCenterInSuperviewMargins()
                self.label.isHidden = false
                self.taskTableView.reloadData()
            } else {
                
                self.label.isHidden = true
                self.taskTableView.reloadData()
            }
        }
        
    }
}


extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
        let entitie = datasource![indexPath.row]
        let model = TaskResume(
            id: entitie.tarea?.id,
            title: entitie.tarea?.tituloTarea ?? "",
            state: entitie.estadoTarea ?? "",
            time: entitie.tarea?.progresoTarea ?? "",
            fechaTermino: entitie.tarea?.fechaLimite ?? "",
            fechaInicio: entitie.tarea?.fechaInicio ?? ""
        )
        cell.configure(model)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entite = datasource![indexPath.row]
        let viewController = DetailTaskViewController(entite)
        viewController.modalPresentationStyle = .overCurrentContext
        self.present(viewController, animated: true)
        
    }
    
    //MARK: - swipe
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var stack = [UITableViewRowAction]()
        let entite = datasource![indexPath.row]
        
        if Int(entite.estadoTarea!) == 2{  // Finalizar
            let finalizarAction = UITableViewRowAction(style: .normal, title: "\u{2713}\n Finalizar") { [self] action, indexPath in
                self.viewmodel.editStateTask(entite, 3)
                self.indexPath = indexPath
                //notifications
                viewmodel.createNotifications(notificador: (entite.user!.id)!, notificado: entite.asignador!, message: "Se ha finalizado la tarea \(entite.tarea!.tituloTarea!)", is_read: false, tareaId: (entite.tarea?.id)!)
            }
            
            
            finalizarAction.backgroundColor = UIColor(hexFromString: "#b0f2c2")
            stack.append(finalizarAction)

        }
        
        if Int(entite.estadoTarea!) == 1 {  // Trabajando
            let backlogAction = UITableViewRowAction(style: .normal, title: "\u{2713}\n Iniciar") { [self] action, indexPath in
                self.viewmodel.editStateTask(entite, 2)
                self.indexPath = indexPath
                viewmodel.createNotifications(notificador: entite.user!.id!, notificado: entite.asignador!, message: "Se ha iniciado la tarea \(entite.tarea!.tituloTarea!)", is_read: false, tareaId: entite.tarea!.id!)
            }
            backlogAction.backgroundColor = UIColor(hexFromString: "#84b6f4")
            
            stack.append(backlogAction)
            

        }
        
        if Int(entite.estadoTarea!) == 0 { // sin asignar
            let aceptarAction = UITableViewRowAction(style: .normal, title: "\u{2713}\n Aceptar") { action, indexPath in
                self.viewmodel.editStateTask(entite, 4)
                self.indexPath = indexPath
                self.viewmodel.createNotifications(notificador: entite.user!.id!, notificado: entite.asignador!, message: "Se ha aceptado la tarea \(entite.tarea!.tituloTarea!)", is_read: false, tareaId: entite.tarea!.id!)
            }
            aceptarAction.backgroundColor = UIColor(hexFromString: "#b0f2c2")
            
            
            let rechazarAction = UITableViewRowAction(style: .normal, title: "\u{0058}\n Rechazar") { action, indexPath in
                
                let viewController = ReportViewController()
                viewController.entitie = entite
                viewController.modalPresentationStyle = .overCurrentContext
                self.present(viewController, animated: true)
                
                
                
                
//                self.viewmodel.editStateTask(entite, 5)
//
//                self.indexPath = indexPath
//                self.viewmodel.createNotifications(notificador: entite.user!.id!, notificado: entite.asignador!, message: "Se ha rechazado la tarea \(entite.tarea!.tituloTarea!)", is_read: false, tareaId: entite.tarea!.id!)
//
//
                
            }
            rechazarAction.backgroundColor = UIColor(hexFromString: "#ff6961")
            aceptarAction.backgroundColor = UIColor(hexFromString: "#b0f2c2")
            
            
            stack.append(rechazarAction)
            stack.append(aceptarAction)
        }
        if Int(entite.estadoTarea!) == 3 { // por empezar
            stack.removeAll()
        }
        
        if Int(entite.estadoTarea!) == 4 { // por empezar
            let backlogAction = UITableViewRowAction(style: .normal, title: "\u{2713}\n Iniciar") { [self] action, indexPath in
                self.viewmodel.editStateTask(entite, 2)
                self.indexPath = indexPath
            }
            backlogAction.backgroundColor = UIColor(hexFromString: "#84b6f4")
            viewmodel.createNotifications(notificador: entite.user!.id!, notificado: entite.asignador!, message: "Se ha iniciado la tarea \(entite.tarea!.tituloTarea!)", is_read: false, tareaId: entite.tarea!.id!)
            stack.append(backlogAction)
        }
        
        
        
        return stack
    }
}

extension TaskListViewController: UITableViewDelegate {
    
}

extension TaskListViewController {
    
    private func subscriptions(){
        fetchMyTaskSubscription()
        reloadTableSubscription()
    }
    
    private func fetchMyTaskSubscription(){
        viewmodel.myTask.subscribe(onNext: { [weak self] response in
            guard let self = self else { return }
            
            self.listMyTask = response.filter({ usertarea in
                Int(usertarea.estadoTarea!) != 5
            })
            self.datasource = self.listMyTask
            var index = 0
            if !self.filterTask.text!.isEmpty {
                index = self.filterTask.selectedIndex!
            }
            
            if self.datasource!.count > 0 {
                self.datasource = self.datasource!.filter({ userTare in
                    Int(userTare.estadoTarea!)  == index
                })
            }else {
                self.taskTableView.addSubview(self.label)
                self.label.autoCenterInSuperviewMargins()
                self.label.isHidden = false
                self.taskTableView.reloadData()
            }
            
            
            if self.datasource!.count == 0 {
                self.taskTableView.addSubview(self.label)
                self.label.autoCenterInSuperviewMargins()
                self.label.isHidden = false
            }
            self.taskTableView.reloadData()
        }).disposed(by: disposeBag)
    }
    
    private func reloadTableSubscription(){
        
        viewmodel.reloadTable.subscribe(onNext: { [weak self] _ in
            self!.viewmodel.getTaskForUserLoged()
            
        }).disposed(by: disposeBag)
        
    }
}
