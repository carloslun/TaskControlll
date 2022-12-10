//
//  Unidad.swift
//  TaskControl
//
//  Created by Carlos Luna Salazar on 13-11-22.
//

import Foundation

struct Unidad: Decodable {
    let id: Int?
    let unidadName: String?
    let dir: Dir?
}

// MARK: - Dir
struct Dir: Decodable {
    let id: Int?
    let dirName: String?
}
