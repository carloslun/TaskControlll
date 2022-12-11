import Foundation
import Alamofire
import RxSwift

class TaskViewModel {
    var taskProvider = TaskProvider()
    
    var users = PublishSubject<[UserLogin]>()
    var myTask = PublishSubject<[UserTarea]>()
    var asignamentTask = PublishSubject<Task>()
    var showSuccesCreateTask = PublishSubject<Void>()
    var listNotification = PublishSubject<[NotificationsModel]>()
    var myAsignamentTask = PublishSubject<[UserTarea]>()
    var taskbyid = PublishSubject<[UserTarea]>()
    var taskreAsign = PublishSubject<Void>()
    var reloadTable = PublishSubject<Void>()
    var myFlow = PublishSubject<[UserFlujo]>()
    
    required init() {
        
    }
    
    func createTask(_ task: Task) {
        taskProvider.createTask(task) { [weak self] response in
            switch response.result {
            case .success(let success):
                self!.asignamentTask.onNext(success)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getUsers(){
        taskProvider.getUsers(){ [weak self] response in
            switch response.result {
            case .success(let success):
                self!.users.onNext(success)
            case .failure(let error):
                break
            }
        }
    }
    
    // MARK: - Dashboard
    func getTaskForUserLoged(){
        taskProvider.getTaskForUserLoged(){ [weak self] response in
            switch response.result {
            case .success(let success):
                self!.myTask.onNext(success)
            case .failure(let error):
                break
            }
        }
    }
    
    func endedCreateTask(_ endedCreateTask: Asignament){
        taskProvider.endedCreateTask(endedCreateTask){ [weak self] response in
            switch response.result {
            case .success(let success):
                self!.showSuccesCreateTask.onNext(Void())
//                self!.myTask.onNext(success)
            case .failure(let error):
                break
            }
            
        }
    }
    
    func editStateTask(_ userTarea: UserTarea, _ newState: Int){
        taskProvider.editStateTask(userTarea, newState){ [weak self] response in
            switch response.result {
            case .success(let success):
                self!.reloadTable.onNext(Void())
            case .failure(let error):
                break
            }
            
        }
    }
    
    
    func createNotifications(notificador: Int, notificado: Int, message: String, is_read: Bool, tareaId: Int ){
        taskProvider.createNotifications(notificador: notificador, notificado: notificado, message: message, is_read: is_read, tareaId: tareaId) { [weak self] response in
            switch response.result {
            case .success(let success):
                print(success)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getNotifications() {
        taskProvider.getNotifications { [weak self] response in
            switch response.result {
            case .success(let success):
                self?.listNotification.onNext(success)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getTaskAsignamentForMe(){
        taskProvider.getTaskAsignamentForMe { [weak self] response in
            switch response.result {
            case .success(let success):
                self?.myAsignamentTask.onNext(success)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getTaskById(id: Int) {
        taskProvider.getTaskById(id: id) { [weak self] response in
            switch response.result {
            case .success(let success):
                self?.taskbyid.onNext(success)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func asignamentTask(userTarea: UserTarea, newUser: Int) {
        taskProvider.asignamentTask(userTarea, newUser) { [weak self] response in
            switch response.result {
            case .success(let success):
                print("H")
                self?.taskreAsign.onNext(Void())
            case .failure(let error):
                print(error)
            }
        }
    }
    func getFlowByMyUser(){
        taskProvider.getFlowByMyUser { [weak self] response in
            switch response.result {
            case .success(let success):
                self!.myFlow.onNext(success)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
