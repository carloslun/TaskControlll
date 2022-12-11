import Foundation
import UIKit

class UserContextManager: NSObject {
    private static var instance: UserContextManager?
    
    class var shared: UserContextManager {
        guard let instance = self.instance else {
            let instance = UserContextManager()
            self.instance = instance
            return instance
        }
        return instance
    }
    
    class func destroy() {
         instance = nil
    }
    
    var token: String?
    var id: Int?
    var user: Login?
    
}

class stateContext: NSObject {
    private static var instance: stateContext?
    
    class var shared: stateContext {
        guard let instance = self.instance else {
            let instance = stateContext()
            self.instance = instance
            return instance
        }
        return instance
    }
    
    class func destroy() {
         instance = nil
    }
    
    var options = [
        "Asignada",// 0
        "Por empezar",// 1
        "En progreso",// 2
        "Finalizada",// 3
        "Aceptada",// 4
        "Rechazada"// 5
    ]
    
    var semaforo = [
        UIColor(hexFromString: "#77dd77"),//verde
        UIColor(hexFromString: "#fdfd96"),//naranjo
        UIColor(hexFromString: "#ff6961"),//rojo
        .white
    ]
    
//    var colors = [
//        UIColor(hexFromString: "#84b6f4"),
//        UIColor(hexFromString: "#f5fac1"),
//        UIColor.white,
//        UIColor(hexFromString: "#b0f2c2")
//    ]
    
    func getProgress(fechaTermino: String) -> String{
        let endDateString = fechaTermino
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        let endDate = formatter.date(from: endDateString)
        
        let timeHours = ((Int(endDate!.timeIntervalSinceNow)/60)/60)/24
        if timeHours > 0 {
            print(" > ")
            return String(timeHours)
            // Revisar que color pintar
        }
        
        if timeHours == 0 {
            print("=")
            return String(timeHours)
            //pintar amarillo vence hoy
        }
        
        if timeHours < 0 {
            // atrasados pintar rojo
            print("<")
            return String(timeHours)
        }
        return ""
    }
    
    func getPorcentualProgressForTask(fechaInicio: String, fechaTermino: String) -> Double {
        let endDateString = fechaTermino
        let startDateString = fechaInicio
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        
        let endDate = formatter.date(from: endDateString)
        let startDate = formatter.date(from: startDateString)
        
        let time = (((endDate!.timeIntervalSince(startDate!) as! Double)/60)/60)/24
        let diasQuedan = getProgress(fechaTermino: fechaTermino)
        let result = ((time as! Double - Double(diasQuedan)!) * 100) / time
        return result
        
        
    }
    
}
