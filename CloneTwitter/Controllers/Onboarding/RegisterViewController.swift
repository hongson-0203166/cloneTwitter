//
//  RegisterViewController.swift
//  CloneTwitter
//
//  Created by Phạm Hồng Sơn on 19/02/2024.
//

import UIKit
import SnapKit
import FirebaseAuth
class RegisterViewController: UIViewController {
    private let registerTitleLable: UILabel = {
        let lable = UILabel()
        lable.text = "Create your account"
        lable.font = UIFont.systemFont(ofSize: 32,weight: .bold)
        return lable
    }()
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
            )
        textField.becomeFirstResponder()
        textField.keyboardType = .emailAddress
        
        textField.returnKeyType = .next
        return textField
    }()
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
            )
        textField.returnKeyType = .done
       
        textField.isSecureTextEntry = true
        return textField
    }()
    private let lineBottomEmail: UIView = {
        let view = UIView()
        view.backgroundColor = .secondaryLabel
        return view
    }()
    private let lineBottomPassword: UIView = {
        let view = UIView()
        view.backgroundColor = .secondaryLabel
        return view
    }()
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create account", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16,weight: .bold)
        button.tintColor = .white
        button.backgroundColor = .twitterBlueColor
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 25
        button.isEnabled = false
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(registerTitleLable)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(registerButton)
        view.addSubview(lineBottomEmail)
        view.addSubview(lineBottomPassword)
        configureConstrains()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapToDismiss)))
        registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        binViews()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    
    @objc func didTapRegister(){
        guard let email = emailTextField.text,let password = passwordTextField.text else{
            return
        }
        AuthManager.shared.registerUser(email: email, password: password) { result in
            switch result {
            case.success(let user):
                self.navigationController?.pushViewController(HomeViewController(), animated: true)
                print("Đăng ký thành công: \(user.uid)")
                DatabaseManager.shared.collectionUsers(add: user) { result in
                    print("Thêm ngừoi dùng thất bại: \(result)")
                }
                break
            case .failure(let error):
                self.presentAlert(error: error.localizedDescription)
                break
            }
        }
    }
    @objc func didTapToDismiss(){
        view.endEditing(true)
    }
    @objc private func handleTextFieldEditingChanged(_ textField: UITextField) {
        registerButton.isEnabled = validateRegistationForm()
    }
    private func binViews(){
        emailTextField.addTarget(self, action: #selector(handleTextFieldEditingChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(handleTextFieldEditingChanged) , for: .editingChanged)
    }
    public func validateRegistationForm() -> Bool{
        guard let email = emailTextField.text, let password = passwordTextField.text else{
            return false
        }
        return (isValidEmail(email) && password.count >= 6)
    }
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    private func configureConstrains(){
        registerTitleLable.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalToSuperview().offset(100)
        }
        emailTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(registerTitleLable.snp.bottom).offset(20)
            make.width.equalTo(view.snp.width).offset(-40)
            make.centerX.equalToSuperview()
            make.height.equalTo(60)
        }
        lineBottomEmail.snp.makeConstraints { make in
            make.leading.equalTo(emailTextField)
            make.top.equalTo(emailTextField.snp.bottom).offset(-3)
            make.width.equalTo(emailTextField)
            make.height.equalTo(1)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(emailTextField.snp.bottom).offset(15)
            make.width.equalTo(view.snp.width).offset(-40)
            make.centerX.equalToSuperview()
            make.height.equalTo(60)
        }
        lineBottomPassword.snp.makeConstraints { make in
            make.leading.equalTo(passwordTextField)
            make.top.equalTo(passwordTextField.snp.bottom).offset(-3)
            make.width.equalTo(passwordTextField)
            make.height.equalTo(1)
        }
        registerButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.width.equalTo(180)
            make.height.equalTo(50)
        }
    }
    private func presentAlert(error: String){
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
extension RegisterViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField{
            passwordTextField.becomeFirstResponder()
        }else if textField == passwordTextField{
            didTapRegister()
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        return true
    }
}
