//
//  AuthViewController.swift
//  MyInstagram
//
//  Created by Иван Знак on 15/01/2024.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseDatabase

class AuthViewController: UIViewController {
    var singUp: Bool = true {
        willSet{
            if newValue {
//                nameField.isHidden = true
//                titleLabel.text = "Login"
//                buttonSwitchStatus.setTitle("Do you not have account?", for: .normal)
//                buttonSing.setTitle("Login", for: .normal)
                
                nameField.isHidden = false
                titleLabel.text = "Registration"
                buttonSwitchStatus.setTitle("Do you have already account?", for: .normal)
                buttonSing.setTitle("SignUp", for: .normal)
            }else{
//                nameField.isHidden = false
//                titleLabel.text = "Registration"
//                buttonSwitchStatus.setTitle("Do you have already account?", for: .normal)
//                buttonSing.setTitle("SignUp", for: .normal)
                
                nameField.isHidden = true
                titleLabel.text = "Login"
                buttonSwitchStatus.setTitle("Do you not have account?", for: .normal)
                buttonSing.setTitle("Login", for: .normal)
            }
        }
    }
    
    let titleLabel = UILabel()
    let nameField = UITextField()
    let emailField = UITextField()
    let passwordField = UITextField()
    let buttonSwitchStatus = UIButton(type: .custom)
    let buttonSing = UIButton(type: .custom)
    let stackView = UIStackView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.setNavigationBarHidden(true, animated: false)
        constraints()
        
        nameField.isHidden = false
        titleLabel.text = "Registration"
        buttonSwitchStatus.setTitle("Do you have already account?", for: .normal)
        buttonSwitchStatus.setTitleColor(.systemBlue, for: .normal)
        buttonSing.setTitle("SignUp", for: .normal)
        buttonSing.backgroundColor = .systemBlue
        buttonSing.layer.cornerRadius = 10
        buttonSwitchStatus.addTarget(self, action: #selector(buttonSwitchStatusTarget), for: .touchUpInside)
        buttonSing.addTarget(self, action: #selector(buttonSignTarget), for: .touchUpInside)
        emailField.placeholder = "Enter your email"
        emailField.borderStyle = .roundedRect
        passwordField.placeholder = "Enter your password"
        passwordField.borderStyle = .roundedRect
        nameField.placeholder = "Enter your name"
        nameField.borderStyle = .roundedRect
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        
    }
    private func constraints(){
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        buttonSwitchStatus.translatesAutoresizingMaskIntoConstraints = false
        buttonSing.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        stackView.addArrangedSubview(nameField)
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(passwordField)
        view.addSubview(stackView)
        view.addSubview(buttonSwitchStatus)
        view.addSubview(buttonSing)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            buttonSwitchStatus.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            buttonSwitchStatus.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buttonSing.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonSing.topAnchor.constraint(equalTo: buttonSwitchStatus.bottomAnchor, constant: 10),
            buttonSing.widthAnchor.constraint(equalTo: buttonSing.heightAnchor, multiplier: 4/1),
            buttonSing.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    @objc func buttonSwitchStatusTarget(){
        singUp.toggle()
    }
}
extension AuthViewController{
   
    @objc func buttonSignTarget(){
        let name = nameField.text!
        let email = emailField.text!
        let password = passwordField.text!
        
        if singUp{
            if(!name.isEmpty && !email.isEmpty && !password.isEmpty){
                
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    
                    if error == nil {
                        
                        if let result = result {
                            Firestore.firestore().document("\(result.user.uid)/accountInformation").setData(["name" : name, "email": email])
                            
                            print(result.user.uid)
                        }
                        self.navigationController?.pushViewController(TabBarController(), animated: true)
                    }
                }
                
            }else{
                showAlert(title: "Please", message: "Enter your textfields")
            }
        }else{
            if (!email.isEmpty && !password.isEmpty){
                Auth.auth().signIn(withEmail: email, password: password) { result, error in
                    if error == nil {
                        self.navigationController?.pushViewController(TabBarController(), animated: true)
                    } else {
                        self.showAlert(title: "Error", message: "Wrong password or login")
                    }
                }
            } else {
                showAlert(title: "Please", message: "Enter your textfields")
            }
        }
    }
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
}
