//
//  NotificationsModel.swift
//  TaskControl
//
//  Created by Carlos Luna Salazar on 03-12-22.
//

import Foundation
struct NotificationsModel: Decodable {
    let id, idNotificador, idNotificado: Int
    let mensaje, fechaCreacion: String
    let isRead: Bool
    let tarea: Task
}
