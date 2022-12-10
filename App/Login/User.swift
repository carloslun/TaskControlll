import Foundation

// MARK: - Welcome
struct Login: Decodable {
    let token: String?
    let user: UserLogin?
    let message: String?
}

// MARK: - User
struct UserLogin: Decodable {
    let email, name, lastName: String?
    let creador, id: Int?
    let rol: Rol?
    let cargo: Cargo?
    let unidad: Unidad?
}
