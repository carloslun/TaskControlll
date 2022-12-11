//
//  DetailTaskViewController.swift
//  TaskControl
//
//  Created by Carlos Luna Salazar on 27-11-22.
//

import UIKit
import iOSDropDown
import RxSwift

class DetailTaskViewController: UIViewController {
    let backgrounds = [
        UIColor(hexFromString: "#84b6f4"),
        UIColor(hexFromString: "#f5fac1"),
        UIColor.white,
        UIColor(hexFromString: "#b0f2c2")
    ]
    
    var  usuarioAsignador: UserLogin?
    let statusTask = stateContext.shared.options
    
    let viewModelTask = TaskViewModel()
    private var listUser = [UserLogin]()
    private var disposeBag = DisposeBag()
    
    @IBOutlet weak var titleTask: UILabel!
    @IBOutlet weak var FinishedTaskStack: UIStackView!
    @IBOutlet weak var ResportTask: UIImageView!
    @IBOutlet weak var UserReasign: DropDown!
    @IBOutlet weak var FinishedTaskButton: UIButton!
    @IBOutlet weak var aceptTaskButton: UIButton!
    @IBOutlet weak var acceptOrDeclive: UIStackView!
    @IBOutlet weak var dateStart: UILabel!
    @IBOutlet weak var decliveTaskButton: UIButton!
    @IBOutlet weak var reasignarTaskButton: UIButton!
    var indexUser: Int?
    var taskDetail: UserTarea!
    @IBOutlet weak var asignament: UILabel!
    
    @IBOutlet weak var descriptionTask: UILabel!
    @IBOutlet weak var stateTask: UILabel!
    @IBOutlet weak var limitDate: UILabel!
    
    
    @IBOutlet weak var titleToClip: UIView!
    
    @IBOutlet weak var infortationToClip: UIView!
    
    @IBOutlet weak var progressToClip: UIView!
    
    @IBOutlet weak var descriptionTClip: UILabel!
    
    @IBOutlet weak var progressTask: UILabel!
    @IBOutlet weak var reasignarToClip: UIStackView!
    
    @IBOutlet weak var reasignarToClipview: UIView!
    @IBOutlet var gradientView: GradientView!
    
    var diasProgreso = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAsignamentDropDown()
        subscriptions()
        viewModelTask.getUsers()
      
        let idString = String(self.taskDetail.tarea?.id! ?? 0)
        titleTask.text = "#\(idString) \(taskDetail.tarea!.tituloTarea!)"

        let days = Int(stateContext.shared.getProgress(fechaTermino: (taskDetail.tarea?.fechaLimite!)!))!
        
        
        let _ = stateContext.shared.getPorcentualProgressForTask(fechaInicio: (taskDetail.tarea?.fechaInicio!)!, fechaTermino: (taskDetail.tarea?.fechaLimite!)!)

        
        stateTask.text = "Estado: \(  statusTask[Int(taskDetail.estadoTarea!)!]  )"
        descriptionTask.text = taskDetail.tarea!.descripcionTarea!
        limitDate.text = "Fecha limite:  \(taskDetail.tarea!.fechaLimite!)"

        dateStart.text = "Fecha inicio: \(taskDetail.tarea!.fechaInicio!)"
        
        titleToClip.layer.cornerRadius = 5
        titleToClip.clipsToBounds = true
        
        
        infortationToClip.layer.cornerRadius = 5
        infortationToClip.clipsToBounds = true
        
        descriptionTClip.layer.cornerRadius = 5
        descriptionTClip.clipsToBounds = true
        
        
        reasignarToClipview.layer.cornerRadius = 5
        reasignarToClipview.clipsToBounds = true
        
        
        let _ = stateContext.shared.getProgress(fechaTermino: (taskDetail.tarea?.fechaLimite!)!)
        
        if taskDetail.asignador == UserContextManager.shared.id {
            reasignarToClip.isHidden = false
        }else {
            reasignarToClip.isHidden = true
        }

        if taskDetail.asignador == UserContextManager.shared.id {
            reasignarToClipview.isHidden = false
        } else {
            reasignarToClip.isHidden = true
        }
        
        
    }
    
    init(_ task: UserTarea ) {
        super.init(nibName: nil, bundle: nil)
        taskDetail = task
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setAsignamentDropDown(){
        UserReasign.isSearchEnable = false
        UserReasign.didSelect { selectedText, index, id in
            self.indexUser = index
        }
    }
    
    @IBAction func goToHome(_ sender: Any) {
        let viewController = NavsViewController()
        viewController.modalPresentationStyle = .overCurrentContext
        self.present(viewController, animated: true)
    }
    
    
    @IBAction func reportTapped(_ sender: Any) {
    }
    @IBAction func reasignTapp(_ sender: Any) {
        let user = listUser[indexUser!]

        viewModelTask.asignamentTask(userTarea: taskDetail, newUser: user.id!)
        
        viewModelTask.createNotifications(notificador: (UserContextManager.shared.user?.user?.id!)!, notificado: user.id!, message: "Se ha reasignado la tarea \(taskDetail.tarea?.tituloTarea!)", is_read: false, tareaId: (taskDetail.tarea?.id!)!)

        
    }
    
    @IBAction func deleteTask(_ sender: Any) {
    }
}

extension DetailTaskViewController {
    private func subscriptions(){
        getUsersSubscription()
        asignamentTaskSubscription()
    }
    
    private func getUsersSubscription(){
        viewModelTask.users.subscribe(onNext: { response in
            for user in response {
                self.listUser.append(user)
            }
            self.listUser.forEach { user in
                if let name = user.name,
                   let lastName = user.lastName {
                    self.UserReasign.optionArray.append("\(name) \(lastName)")
                }
            }
            
            self.usuarioAsignador = self.listUser.filter({ user in
                user.id == self.taskDetail.asignador
            }).first
            self.asignament.text = "Asignado por: \(self.usuarioAsignador!.name!) \(self.usuarioAsignador!.lastName!)"
        }).disposed(by: disposeBag)
    }
    
    private func asignamentTaskSubscription(){
        viewModelTask.taskreAsign.subscribe(onNext: { [weak self] _ in
                        
            
            
            let viewController = CongratsViewController("Haz reasignado una tarea correctamente", status: Status.success)
            viewController.modalPresentationStyle = .overCurrentContext
            self!.present(viewController, animated: true)
            
        }).disposed(by: disposeBag)
    }
    
    
    
    
    
}

