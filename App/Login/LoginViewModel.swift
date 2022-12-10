import Foundation
import Alamofire
import RxSwift

class LoginViewModel: LoginViewModelProtocol {
    var goToHomeObservable: PublishSubject<Login>?
    var showErrorObservable: PublishSubject<String>?
    private var loginProvider: LoginProviderProtocol?
  
    required init(provider: LoginProviderProtocol = LoginProvider()) {
        loginProvider = provider
        goToHomeObservable = PublishSubject<Login>()
        showErrorObservable = PublishSubject<String>()
    }
    
    func login(withUser username: String, withPassword password: String) {
        loginProvider?.login(withUsername: username, withPassword: password){ [weak self] response in
            switch response.result {
            case .success(let login):
                self!.didGetResponse(withLogin: login)
            case .failure(let error):
                print("todo mal \(error.localizedDescription)")
            }
        }
    }
    
    private func didGetResponse(withLogin login: Login){
        guard let token = login.token else {
            //show Error
            showErrorObservable?.onNext("No se pudo validar el usuario ingresado, intente nuevamente")
            return
        }
        
        if login.user?.rol?.rolName == "Funcionario" {
            // MARK: - Cambiar en el futuro por id
            goToHomeObservable?.onNext(login)
        }
    }
}
