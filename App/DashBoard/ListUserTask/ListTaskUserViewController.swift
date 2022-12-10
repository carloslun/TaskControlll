//
//  ListTaskUserViewController.swift
//  TaskControl
//
//  Created by Carlos Luna Salazar on 30-11-22.
//

import UIKit
import iOSDropDown
import RxSwift

class ListTaskUserViewController: UIViewController {
    
    var datasource: [UserTarea]? = [] {
        didSet {
            datasource!.sort { userOne, userTwo in
                userOne.estadoTarea! < userTwo.estadoTarea!
            }
            self.userTableView.reloadData()
        }
    }
    
    
    
    private var tareaTask = [UserTarea]()
    private var listUser = [UserLogin]()

    @IBOutlet weak var userDropdown: DropDown!
    let viewmodel = TaskViewModel()
    private var disposeBag = DisposeBag()
    
    @IBOutlet weak var userTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userTableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskTableViewCell")
        userTableView.dataSource = self
        userTableView.delegate = self
        taskAsignamentForMeSubscription()
        getUsersSubscription()
        viewmodel.getUsers()
        viewmodel.getTaskAsignamentForMe()
        userDropdown.isSearchEnable = false
        userDropdown.didSelect { selectedText, index, id in
            let id = self.listUser[index].id
            self.datasource = self.tareaTask.filter({ userTask in
                userTask.user?.id == id
            })
            self.userTableView.reloadData()
            
            
        }
        
        
        

        // Do any additional setup after loading the view.
    }

}

extension ListTaskUserViewController: UITableViewDelegate {
    
}

extension ListTaskUserViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        (datasource?.count)!
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
        let entitie = datasource![indexPath.row]
        let taskResume = TaskResume(
            id: entitie.tarea?.id ?? 0,
            title: entitie.tarea?.tituloTarea ?? "",
            state: entitie.estadoTarea ?? "",
            time: entitie.tarea?.progresoTarea ?? "",
            fechaTermino: entitie.tarea?.fechaLimite ?? "",
            fechaInicio: entitie.tarea?.fechaInicio ?? ""
        )
        cell.configure(taskResume)
        
        return cell
    }
    
    
}

extension ListTaskUserViewController {
    func taskAsignamentForMeSubscription(){
        viewmodel.myAsignamentTask.subscribe(onNext: { [weak self] usertarea in
            self?.tareaTask = usertarea
            self!.datasource = self?.tareaTask
            
        }).disposed(by: disposeBag)
    }
    private func getUsersSubscription(){
        viewmodel.users.subscribe(onNext: { response in
            for user in response {
                self.listUser.append(user)
            }
            self.listUser.forEach { user in
                if let name = user.name,
                   let lastName = user.lastName {
                    self.userDropdown.optionArray.append("\(name) \(lastName)")
                }
            }
            self.userTableView.reloadData()
        }).disposed(by: disposeBag)
    }
}
