//
//  NotificationsViewController.swift
//  TaskControl
//
//  Created by Carlos Luna Salazar on 03-12-22.
//

import UIKit
import RxSwift

class NotificationsViewController: UIViewController {
    
    
    var datasource: [NotificationsModel]? = [] {
        didSet {
            datasource!.sort { userOne, userTwo in
                userOne.id > userTwo.id
            }
            self.notificationsTableView.reloadData()
            print(datasource)
        }
    }
    let viewmodel = TaskViewModel()
    private var disposeBag = DisposeBag()
    @IBOutlet weak var notificationsTableView: UITableView!
    var notificationList = [NotificationsModel]()
    override func viewDidLoad() {
        super.viewDidLoad()

        notificationsTableView.register(UINib(nibName: "NotificationsTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationsTableViewCell")
        notificationsTableView.dataSource = self
        notificationsTableView.delegate = self
        notificationSubscription()
        taskSubcription()
        viewmodel.getNotifications()
    }


}


extension NotificationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        datasource!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsTableViewCell", for: indexPath) as! NotificationsTableViewCell
        let notification = datasource![indexPath.row]
        
      
        cell.configure(model: notification)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entite = datasource![indexPath.row]
        print(entite)
        viewmodel.getTaskById(id: entite.tarea.id!)
//        let userTarea = UserTarea(
//            id: nil,
//            user: nil,
//            tarea: entite.tarea,
//            estadoTarea: nil,
//            asignador: nil
//        )
//        let viewController = DetailTaskViewController(userTarea)
//        viewController.modalPresentationStyle = .overCurrentContext
//        self.present(viewController, animated: true)
    }
    
    
}

extension NotificationsViewController: UITableViewDelegate {
    
}

extension NotificationsViewController {
    
    func notificationSubscription(){
        viewmodel.listNotification.subscribe(onNext: { [weak self] response in
            
            self?.notificationList = response.filter({ notification in
                notification.idNotificado == UserContextManager.shared.user?.user?.id!
            })
            self?.datasource = self?.notificationList
            
            self?.notificationsTableView.reloadData()
        }).disposed(by: disposeBag)
    }
    
    func taskSubcription(){
        viewmodel.taskbyid.subscribe(onNext: {[weak self] tarea in
            
            let viewController = DetailTaskViewController(tarea.first!)
            viewController.modalPresentationStyle = .overCurrentContext
            self!.present(viewController, animated: true)
        }).disposed(by: disposeBag)
    }
}
