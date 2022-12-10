import UIKit
import iOSDropDown
import RxSwift
import Alamofire

class TaskViewController: UIViewController, UITextViewDelegate {
    let viewModel = TaskViewModel()
    private var disposeBag = DisposeBag()
    private var listUser = [UserLogin]()
    var indexUser: Int?
    var indexState: Int?
    
    @IBOutlet weak var titleTaskTextField: UITextField!
    @IBOutlet weak var descriptionTaskTextField: UITextView!
    @IBOutlet weak var startTaskDatePicker: UIDatePicker!
    @IBOutlet weak var stateTaskDropDown: DropDown!
    @IBOutlet weak var endTaskDatePicker: UIDatePicker!
    @IBOutlet weak var ResponsibleTaskTextField: UIView!
    @IBOutlet weak var createTaskButton: UIButton!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var asignmentDropDown: DropDown!
    
    var helperStateTask = ""
    
    let errorMessageValue = "No puedes enviar un campo vacio"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscriptions()
        setStateDropDown()
        setAsignamentDropDown()
        errorMessageLabel.text = ""
        titleTaskTextField.delegate = self
        descriptionTaskTextField.delegate = self
        viewModel.getUsers()
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func createTaskButtonPressed(_ sender: Any) {
        if isValid() {
            createTask()
        }
    }
}

// MARK: - Private function
extension TaskViewController {
    private func isValid() -> Bool{
        if titleTaskTextField.text?.isEmpty ?? true ||
           descriptionTaskTextField.text?.isEmpty ?? true ||
//           stateTaskDropDown.text?.isEmpty ?? true ||
           asignmentDropDown.text?.isEmpty ?? true
        {
            errorMessageLabel.text = errorMessageValue
            return false
            
        } else
        {
            errorMessageLabel.text = ""
            return true
        }
    }
    
    private func setStateDropDown(){
        stateTaskDropDown.isSearchEnable = false
        stateTaskDropDown.optionArray = stateContext.shared.options

        stateTaskDropDown.didSelect { selectedText, index, id in
            self.helperStateTask = selectedText
            self.indexState = index
        }
    }
    
    private func setAsignamentDropDown(){
        asignmentDropDown.isSearchEnable = false
        asignmentDropDown.didSelect { selectedText, index, id in

            self.indexUser = index
            
        }
    }
    
    private func formattDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}

// MARK: - Domain
extension TaskViewController {
    private func createTask(){
        createOnlyTask()
    }
    private func createOnlyTask(){
        let startDate = formattDate(startTaskDatePicker.date)
        let endDate = formattDate(endTaskDatePicker.date)
        let task = Task(id: nil, tituloTarea: titleTaskTextField.text, descripcionTarea: descriptionTaskTextField.text, fechaCreacion: nil, fechaInicio: startDate, fechaLimite: endDate.description, plazoTarea: nil, progresoTarea: nil, creadorTarea: UserContextManager.shared.id)
        
        viewModel.createTask(task)
    }
}

// MARK: - Subscription
extension TaskViewController {
    private func subscriptions(){
        getUsersSubscription()
        endedCreateTaskSubscription()
        showSuccessSubcription()
    }
    
    private func getUsersSubscription(){
        viewModel.users.subscribe(onNext: { response in
            for user in response {
                self.listUser.append(user)
            }
            self.listUser.forEach { user in
                if let name = user.name,
                   let lastName = user.lastName {
                    self.asignmentDropDown.optionArray.append("\(name) \(lastName)")
                }
            }
        }).disposed(by: disposeBag)
    }
    
    private func endedCreateTaskSubscription(){
        viewModel.asignamentTask.subscribe(onNext: { [weak self] response in
            let auxUser = self!.listUser[self!.indexUser!]
            let asignamentTask = Asignament(user: auxUser.id!, tarea: response.id!, estadoTarea: 0, asignador: UserContextManager.shared.id!)
            self!.viewModel.createNotifications(notificador: (UserContextManager.shared.user?.user?.id)!, notificado: auxUser.id!, message: "Se te ha Asignado la tarea \(response.tituloTarea!)", is_read: false, tareaId: response.id!)
            self!.viewModel.endedCreateTask(asignamentTask)
            
        }).disposed(by: disposeBag)
    }
    
    private func showSuccessSubcription(){
        viewModel.showSuccesCreateTask.subscribe(onNext: { [weak self] _ in
            
            let viewController = CongratsViewController("Haz creado una tarea Correctamente", status: Status.success)
            viewController.modalPresentationStyle = .overCurrentContext
            self!.present(viewController, animated: true)
            
        }).disposed(by: disposeBag)
    }
}


extension TaskViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTaskTextField.endEditing(true)
        descriptionTaskTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}
