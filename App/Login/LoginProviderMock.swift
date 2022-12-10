import Foundation
import Alamofire

class LoginProviderMock: LoginProviderProtocol {
    func login(withUsername username: String, withPassword password: String, _ completion: @escaping (DataResponse<Login, AFError>) -> Void) {
        // MARK: Code here
    }
    
    
    
    
    
}
