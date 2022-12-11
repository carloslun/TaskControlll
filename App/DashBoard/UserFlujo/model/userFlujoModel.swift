struct UserFlujo: Decodable {
    let id: Int?
    let user: UserLogin?
    let flujo: Flujo?
    let asignador: Int?
}

struct Flujo: Decodable {
    let id: Int?
    let flujoName, descripcionFlujo, fechaCreacion, fechaInicio: String?
    let fechaFin, plazoFlujo: String?
    let creadorFlujo: Int?
    let ejecutar: String?
}
