//
//  UserTarea.swift
//  TaskControl
//
//  Created by Carlos Luna Salazar on 26-11-22.
//

import Foundation

// MARK: - Welcome
struct UserTarea: Decodable {
    let id: Int?
    let user: UserLogin?
    let tarea: Tarea?
    let estadoTarea: String?
    let asignador: Int?
}

// MARK: - Tarea
struct Tarea: Decodable {
    let id: Int?
    let tituloTarea, descripcionTarea, fechaCreacion, fechaInicio: String?
    let fechaLimite, progresoTarea: String?
    let creadorTarea: Int?
}
