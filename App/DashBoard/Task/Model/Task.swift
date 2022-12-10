import Foundation

// MARK: - Task: Decodable
struct Task: Decodable {
    let id: Int?
    let tituloTarea, descripcionTarea, fechaCreacion, fechaInicio: String?
    let fechaLimite, plazoTarea, progresoTarea: String?
    let creadorTarea: Int?
}

