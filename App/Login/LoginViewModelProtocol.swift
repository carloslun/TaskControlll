import Foundation
import RxSwift

protocol LoginViewModelProtocol {
    var goToHomeObservable: PublishSubject<Login>? { get set }
    var showErrorObservable: PublishSubject<String>? { get set }
    
    func login(withUser username: String, withPassword password: String)
}
