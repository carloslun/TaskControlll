import Foundation
import Alamofire

protocol LoginProviderProtocol {
    func login(withUsername username: String, withPassword password: String, _ completion: @escaping (DataResponse<Login, AFError>) -> Void)
}

class LoginProvider: LoginProviderProtocol {
    
    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func login(withUsername username: String, withPassword password: String, _ completion: @escaping (DataResponse<Login, AFError>) -> Void) {
        
        let params = [
            "username": username.lowercased(),
            "password": password
        ]
        
        AF.request("http://imbot.pythonanywhere.com/api/user/login/", method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil)
            .responseDecodable(of: Login.self, decoder: decoder){ (response) in
                completion(response)
                
                
            }

    }

}
