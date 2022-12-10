import Foundation
import UIKit
import PureLayout

class LoginView: UIView {
    
    private let containerStackView: UIStackView = {
        let containerStackView = UIStackView.newAutoLayout()
        containerStackView.axis = .vertical
        containerStackView.spacing = 8
        containerStackView.backgroundColor = .white
        return containerStackView
    }()
    
    lazy var usernameTextField: UITextField = {
        let usernameTextFields = UITextField.newAutoLayout()
        usernameTextFields.placeholder = "Username"
        usernameTextFields.delegate = self
        return usernameTextFields
    }()
    
    lazy var passwordTextField: UITextField = {
        let passwordTextField = UITextField.newAutoLayout()
        passwordTextField.placeholder = "Password"
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
        return passwordTextField
    }()
    
    var didSetupConstraints = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 5
        clipsToBounds = true
        containerStackView.addArrangedSubview(usernameTextField)
        containerStackView.addArrangedSubview(passwordTextField)
        addSubview(containerStackView)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LoginView{
    
    override func updateConstraints() {
        if(!didSetupConstraints){
            containerStackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 10, left: 10.0, bottom: 10.0, right: 10.0))
            didSetupConstraints = true
        }
        super.updateConstraints()
    }
}

// MARK: - TextFieldDelegate
extension LoginView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameTextField.endEditing(true)
        passwordTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}
