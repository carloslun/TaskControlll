import Foundation
import Alamofire

class TaskProvider {
    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    var headers : HTTPHeaders = [
        "Authorization" : "token \(UserContextManager.shared.token!)"
    ]
    
    func createTask(_ task: Task, _ completion: @escaping (DataResponse<Task, AFError>) -> Void) {
        let parameters = [
            "titulo_tarea": task.tituloTarea,
            "descripcion_tarea": task.descripcionTarea,
            "fecha_inicio": task.fechaInicio,
            "fecha_limite": task.fechaLimite,
            "creador_tarea": UserContextManager.shared.id
        ] as [String : Any]
        
        AF.request("https://imbot.pythonanywhere.com/api/tarea/crud-tarea/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                print(response)
            }
            .responseData { response in
                print(response)
            }
            .responseString { response in
                print(response)
            }
            .responseDecodable(of: Task.self, decoder: decoder) { (response) in
                completion(response)
            }
    }
    
    func getRol(_ completion: @escaping (DataResponse<[Rol], AFError>) -> Void) {
        AF.request("http://127.0.0.1:8000/api/rol/crud-rol/", method: .get, encoding: JSONEncoding.default, headers: nil)
            .responseDecodable(of: [Rol].self, decoder: decoder){ (response) in
                completion(response)
        }
    }
    
    func getUnidad(_ completion: @escaping (DataResponse<[Unidad], AFError>) -> Void) {
        AF.request("http://127.0.0.1:8000/api/unidad/crud-unidad/", method: .get, encoding: JSONEncoding.default, headers: nil)
            .responseDecodable(of: [Unidad].self, decoder: decoder){ (response) in
                completion(response)
        }
    }
    
    func getCargo(_ completion: @escaping (DataResponse<[Cargo], AFError>) -> Void) {
        AF.request("http://127.0.0.1:8000/api/cargo/crud-cargo/", method: .get, encoding: JSONEncoding.default, headers: nil)
            .responseDecodable(of: [Cargo].self, decoder: decoder){ (response) in
                completion(response)
        }
    }
    
    func getUsers(_ completion: @escaping (DataResponse<[UserLogin], AFError>) -> Void) {
        AF.request("https://imbot.pythonanywhere.com/api/user/crud-user/", method: .get, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                print(response)
            }
            .responseData { response in
                print(response)
            }
            .responseString { response in
                print(response)
            }
            .responseDecodable(of:
                                [UserLogin].self, decoder: decoder){ (response) in
                completion(response)
        }
    }
    

    // MARK: - Dashboard
    func getTaskForUserLoged(_ completion: @escaping (DataResponse<[UserTarea], AFError>) -> Void){
        
        let parameters = [
            "user": UserContextManager.shared.id
        ]
        AF.request("https://imbot.pythonanywhere.com/api/userTarea/crud-userTarea", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                print(response)
            }
            .responseData { response in
                print(response)
            }
            .responseString { response in
                print(response)
            }
            .responseDecodable(of: [UserTarea].self, decoder: decoder){ (response) in
                completion(response)
        }
    }
    
    func endedCreateTask(_ userTarea: Asignament, _ completion: @escaping (DataResponse<UserTarea, AFError>) -> Void){
        
        let parameters = [
            "user": userTarea.user,
            "tarea": userTarea.tarea,
            "estado_tarea": userTarea.estadoTarea,
            "asignador": userTarea.asignador
        ] as [String : Any]
        
        AF.request("https://imbot.pythonanywhere.com/api/userTarea/crud-userTarea/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                print(response)
            }
            .responseData { response in
                print(response)
            }
            .responseString { response in
                print(response)
            }
            .responseDecodable(of: UserTarea.self, decoder: decoder){ (response) in
                completion(response)
        }
    }
    
    func editStateTask(_ userTarea: UserTarea, _ newState: Int ,_ completion: @escaping (DataResponse<SimpleResponse, AFError>) -> Void){
        let parameters = [
            "estado_tarea": newState,
            "asignador": Int(userTarea.asignador!)
        ]
        AF.request("https://imbot.pythonanywhere.com/api/userTarea/crud-userTarea/\(userTarea.id!)/", method: .put, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                print(response)
            }
            .responseData { response in
                print(response)
            }
            .responseString { response in
                print(response)
            }
            .responseDecodable(of: SimpleResponse.self, decoder: decoder){ (response) in
                completion(response)
        }
    }
    
    func asignamentTask(_ userTarea: UserTarea, _ newUser: Int ,_ completion: @escaping (DataResponse<SimpleResponse, AFError>) -> Void){
        let parameters = [
            
            "estado_tarea": 2,
            "asignador": Int(userTarea.asignador!)
        ]
        AF.request("https://imbot.pythonanywhere.com/api/userTarea/crud-userTarea/\(userTarea.id!)/", method: .put, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                print(response)
            }
            .responseData { response in
                print(response)
            }
            .responseString { response in
                print(response)
            }
            .responseDecodable(of: SimpleResponse.self, decoder: decoder){ (response) in
                completion(response)
        }
    }
    
    func createNotifications(notificador: Int, notificado: Int, message: String, is_read: Bool, tareaId: Int ,_ completion: @escaping (DataResponse<NotificationsModel, AFError>) -> Void) {
        let parameters = [
            
            "id_notificador": notificador,
            "id_notificado": notificado,
            "mensaje": message,
            "is_read": is_read,
            "tarea": tareaId
        ] as [String : Any]
        AF.request("https://imbot.pythonanywhere.com/api/notificacion/crud-notify/", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                print(response)
            }
            .responseData { response in
                print(response)
            }
            .responseString { response in
                print(response)
            }
            .responseDecodable(of: NotificationsModel.self, decoder: decoder){ (response) in
                completion(response)
        }
        
    }
    
    func getNotifications(_ completion: @escaping (DataResponse<[NotificationsModel], AFError>) -> Void) {
        AF.request("https://imbot.pythonanywhere.com/api/notificacion/crud-notify/", method: .get, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                print(response)
            }
            .responseData { response in
                print(response)
            }
            .responseString { response in
                print(response)
            }
            .responseDecodable(of:
                                [NotificationsModel].self, decoder: decoder){ (response) in
                completion(response)
        }
    }
    
    func getTaskAsignamentForMe(_ completion: @escaping (DataResponse<[UserTarea], AFError>) -> Void){
        
        let parameters = [
            "asignador": UserContextManager.shared.id
        ]
        AF.request("https://imbot.pythonanywhere.com/api/userTarea/crud-userTarea", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                print(response)
            }
            .responseData { response in
                print(response)
            }
            .responseString { response in
                print(response)
            }
            .responseDecodable(of: [UserTarea].self, decoder: decoder){ (response) in
                completion(response)
        }
    }
    
    func getTaskById(id: Int, _ completion: @escaping (DataResponse<[UserTarea], AFError>) -> Void){
        
        let parameters = [
            "tarea": id
        ]
        AF.request("https://imbot.pythonanywhere.com/api/userTarea/crud-userTarea", method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                print(response)
            }
            .responseData { response in
                print(response)
            }
            .responseString { response in
                print(response)
            }
            .responseDecodable(of: [UserTarea].self, decoder: decoder){ (response) in
                completion(response)
        }
    }
    
}
