//
//  ReportViewController.swift
//  TaskControl
//
//  Created by Carlos Luna Salazar on 04-12-22.
//

import UIKit

class ReportViewController: UIViewController {
    var entitie: UserTarea?
    var viewmodel = TaskViewModel()
    
    @IBOutlet weak var titleLAbel: UILabel!
    @IBOutlet weak var reportLabel: UILabel!
    @IBOutlet weak var motivoTExt: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(entitie!)
        reportLabel.isHidden = true
        titleLAbel.text = "# \(entitie!.tarea!.id!) \(entitie!.tarea!.tituloTarea!)"
        
        self.hideKeyboardWhenTappedAround()
        
        
    }
    
    @IBAction func reportBitton(_ sender: Any) {
        
        if motivoTExt.text.isEmpty {
            reportLabel.isHidden = false
            reportLabel.text = "No puedes enviar un motivo vacio"
        } else {
            self.viewmodel.editStateTask(entitie!, 5)
            self.viewmodel.createNotifications(notificador: entitie!.user!.id!, notificado: entitie!.asignador!, message: "Se ha rechazado la tarea \(entitie!.tarea!.tituloTarea!)\nMotivo: \(motivoTExt.text ?? "" )", is_read: false, tareaId: entitie!.tarea!.id!)
            reportLabel.isHidden = true
            
            let congratsView = CongratsViewController("Se ha rechazado la Tarea \(entitie!.tarea!.tituloTarea!)", status: .success)
            congratsView.modalPresentationStyle = .overCurrentContext
            self.present(congratsView, animated: true)
             
//            let viewController = NavsViewController()
//            viewController.modalPresentationStyle = .overCurrentContext
//            self.present(viewController, animated: true)
        }
    }
    
    
    @IBAction func goToHome(_ sender: Any) {
        let viewController = NavsViewController()
        viewController.modalPresentationStyle = .overCurrentContext
        self.present(viewController, animated: true)
        
    }
    

}
