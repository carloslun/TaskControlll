import Foundation
import UIKit
import PureLayout
import RxSwift

class LoginViewController: UIViewController {
    let loginView = LoginView()
    let viewModel: LoginViewModelProtocol?
    private var disposeBag = DisposeBag()
    private let titleLabel: UILabel = {
        let titleLabel = UILabel.newAutoLayout()
        titleLabel.text = "TaskControl"
        titleLabel.font = UIFont(name: "Arial Rounded MT Bold", size: 26)
        titleLabel.textColor = .darkGray
        return titleLabel
    }()
    
    private lazy var loginButtom: UIButton = {
        let loginButtom = UIButton.newAutoLayout()
        loginButtom.setTitle("Login", for: .normal)
        loginButtom.addTarget(self, action: #selector(onLoginPressed), for: .touchUpInside)
        loginButtom.configuration = .filled()
        loginButtom.configuration?.imagePadding = 8
        loginButtom.backgroundColor = UIColor(hexFromString: "#b0f2c2")
        return loginButtom
    }()
    
    private let errorMesaggeLabel: UILabel = {
        let errorMesaggeLabel = UILabel.newAutoLayout()
        errorMesaggeLabel.text = ""
        errorMesaggeLabel.numberOfLines = 0
        errorMesaggeLabel.textAlignment = .center
        errorMesaggeLabel.textColor = .red
        errorMesaggeLabel.isHidden = true
        return errorMesaggeLabel
    }()
    
    required init(){
        viewModel = LoginViewModel()
        super.init(nibName: nil, bundle: nil)
        if self.isUserLoged() {
            reload()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        subscriptions()
        self.hideKeyboardWhenTappedAround()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
   
    }
    
    var didSetupConstraints = false
    
    var username: String? {
        return loginView.usernameTextField.text
    }
    
    var password: String? {
        return loginView.passwordTextField.text
    }
}

// MARK: Setup
extension LoginViewController{
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        view.addSubview(loginView)
        view.addSubview(titleLabel)
        view.addSubview(loginButtom)
        view.addSubview(errorMesaggeLabel)
        
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        if (!didSetupConstraints) {
            // titleLabel
            titleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20.0)
            titleLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 20.0)
            titleLabel.autoPinEdge(.bottom, to: .top, of: loginView, withOffset: -10)

            // LoginView
            loginView.autoCenterInSuperview()
            loginView.autoPinEdge(toSuperviewEdge: .left, withInset: 20.0)
            loginView.autoPinEdge(toSuperviewEdge: .right, withInset: 20.0)
            
            // loginButtom
            loginButtom.autoPinEdge(toSuperviewEdge: .left, withInset: 20.0)
            loginButtom.autoPinEdge(toSuperviewEdge: .right, withInset: 20.0)
            loginButtom.autoPinEdge(.top, to: .bottom, of: loginView, withOffset: 10)
            
            // errorMesaggeLabel
            errorMesaggeLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20.0)
            errorMesaggeLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 20.0)
            errorMesaggeLabel.autoPinEdge(.top, to: .bottom, of: loginButtom, withOffset: 10)
            
            didSetupConstraints = true
        }
        super.updateViewConstraints()
        
    }
}

// MARK: - Functions
extension LoginViewController {
    @objc func onLoginPressed(){
//        func_anita@nempresa.cl
//        loginView.usernameTextField.text = "carlos@email.com"
//        loginView.passwordTextField.text = "12345"
        errorMesaggeLabel.isHidden = true
        login()
        
    }
    
    private func login(){
        guard let username = username, let password = password else {
            assertionFailure("Credentials should never be nil")
            return
        }
        
        if username.isEmpty || password.isEmpty {
            configureView(withMessage: "Usuario o contraseña no deben estar en blanco")
            return
        }
        
        viewModel?.login(withUser: username, withPassword: password)
    }
    
    private func configureView(withMessage message: String){
        errorMesaggeLabel.text = message
        errorMesaggeLabel.isHidden = false
    }
    
    private func setPersistenceUser(_ user: Login){
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(password, forKey: "password")
        UserDefaults.standard.set(user.token, forKey: "token")
    }
    
    func isUserLoged() -> Bool{
        guard let username = UserDefaults.standard.string(forKey: "username"),
              !username.isEmpty,
              let password = UserDefaults.standard.string(forKey: "password")
        else { return false }
        return true
    }
    
    func reload(){
        guard let username = UserDefaults.standard.string(forKey: "username"),
              !username.isEmpty,
              let password = UserDefaults.standard.string(forKey: "password")
        else { return }
        viewModel?.login(withUser: username, withPassword: password)
    }
}

extension LoginViewController {
    func subscriptions(){
        goToHomeSubscription()
        showErrorSubscription()
    }
    
    func goToHomeSubscription(){
        viewModel?.goToHomeObservable?.subscribe(onNext: { [weak self] userdata in
            guard let self = self else { return  }
            UserContextManager.shared.token = userdata.token
            UserContextManager.shared.id = userdata.user?.id
            UserContextManager.shared.user = userdata
            if !self.isUserLoged(){
                self.setPersistenceUser(userdata)
            }
            
            let viewController = NavsViewController()
            viewController.modalPresentationStyle = .overCurrentContext
            self.present(viewController, animated: true)
        }).disposed(by: disposeBag)
    }
    
    func showErrorSubscription(){
        viewModel?.showErrorObservable?.subscribe(onNext: { [weak self] errorMenssage in
            self!.configureView(withMessage: errorMenssage)
        }).disposed(by: disposeBag)
    }
}

