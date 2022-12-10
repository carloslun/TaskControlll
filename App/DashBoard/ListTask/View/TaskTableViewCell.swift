//
//  TaskTableViewCell.swift
//  TaskControl
//
//  Created by Carlos Luna Salazar on 26-11-22.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    let estate = stateContext.shared.options
    
    
    @IBOutlet weak var titleTaskLabel: UILabel!
//    @IBOutlet weak var timeTaskLabel: UILabel!
    @IBOutlet weak var stateTaskLabel: UILabel!
    
    @IBOutlet weak var porcentualTask: UILabel!
    @IBOutlet weak var daysLAbel: UILabel!
    @IBOutlet weak var arrowCell: UIImageView!
    @IBOutlet weak var viewBackground: GradientView!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewBackground.layer.cornerRadius = 10
        viewBackground.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
 
    }
    
    func configure(_ model: TaskResume ){
        
        porcentualTask.isHidden = true
        titleTaskLabel.text = "#\(model.id!) \(model.title)"
        stateTaskLabel.text = "Estado: \( estate[(Int(model.state) ?? 0)])"
        
        titleTaskLabel.textColor = .black
        stateTaskLabel.textColor = .black
        arrowCell.tintColor = .black
        let days = stateContext.shared.getProgress(fechaTermino: model.fechaTermino)
        
        var color = UIColor(hexFromString: "#77dd77")
//        if !["0", "3", "4", "5"].contains(where: { valor in
//            model.state == valor
//        }) {
            if Int(days)! > 6 {
                color = stateContext.shared.semaforo[0]
            } else if Int(days)! < 0 {
                color = stateContext.shared.semaforo[2]
            } else {
                color = stateContext.shared.semaforo[1]
            }
        
        if model.state == "3"{
            color = stateContext.shared.semaforo[0]
            daysLAbel.isHidden = true
        }else {
            daysLAbel.text = "Quedan: \(days) dia/s"
            
            let progreso = "0/1" // funcion que calcule el proceso
            
            daysLAbel.isHidden = false
        }
//        } else {
//            color = .white
//        }
            
        (viewBackground as! GradientView).secondColor = color
       
        porcentualTask.text = "Progreso: 1/1000"
        
//        let porcentual = stateContext.shared.getPorcentualProgressForTask(fechaInicio: model.fechaInicio, fechaTermino: model.fechaTermino)
        
//        if type(of: porcentual) != Double.self {
//            return
//        }
        
        
        
//
//        let formatted = String(format: "%.0f", Double(porcentual))
//
//        if formatted != "nan" {
//            if Int(formatted)! > 100 && Int(formatted)! < 0 {
//
//                porcentualTask.isHidden = true
//            } else {
//                porcentualTask.isHidden = false
//                porcentualTask.text = formatted + "%"
//            }
//
////            if model.state == "3" || model.state == "4" || model.state == "5" || model.state == "0" {
////                porcentualTask.isHidden = true
////                daysLAbel.isHidden = true
////            } else if model.state == "1" || model.state == "2" {
////                porcentualTask.isHidden = false
////                daysLAbel.isHidden = false
////            }
//
//
//        } else {
//            porcentualTask.isHidden = true
////            daysLAbel.isHidden = true
//        }
//
        

        
    
    }
    
}
