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
import PhotosUI

class AuthViewController: UIViewController, PHPickerViewControllerDelegate {
    var singUp: Bool = true {
        willSet {
            
            // TODO: use can use ternar operator (?:) for removing redundant if
            if newValue {
                // TODO: remove comments

//                nameField.isHidden = true
//                titleLabel.text = "Login"
//                buttonSwitchStatus.setTitle("Do you not have account?", for: .normal)
//                buttonSing.setTitle("Login", for: .normal)
                
                nameField.isHidden = false
                imageView.isHidden = false
                titleLabel.text = "Registration"
                buttonSwitchStatus.setTitle("Do you have already account?", for: .normal)
                buttonSing.setTitle("SignUp", for: .normal)
            } else {
                // TODO: remove comments

//                nameField.isHidden = false
//                titleLabel.text = "Registration"
//                buttonSwitchStatus.setTitle("Do you have already account?", for: .normal)
//                buttonSing.setTitle("SignUp", for: .normal)
                
                nameField.isHidden = true
                imageView.isHidden = true
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
    let imageView = UIImageView()
    let imageViewLabel = UILabel()
    
    lazy var phPicker: PHPickerViewController = {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        return picker
    }()
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imageViewParameters()
        imageViewLabelParameters()
    }
    
    private func constraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        buttonSwitchStatus.translatesAutoresizingMaskIntoConstraints = false
        buttonSing.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageViewLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        stackView.addArrangedSubview(nameField)
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(passwordField)
        view.addSubview(stackView)
        view.addSubview(imageView)
        view.addSubview(buttonSwitchStatus)
        view.addSubview(buttonSing)
        imageView.addSubview(imageViewLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            imageView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            imageView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            
            buttonSwitchStatus.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            buttonSwitchStatus.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buttonSing.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonSing.topAnchor.constraint(equalTo: buttonSwitchStatus.bottomAnchor, constant: 10),
            buttonSing.widthAnchor.constraint(equalTo: buttonSing.heightAnchor, multiplier: 4/1),
            buttonSing.widthAnchor.constraint(equalToConstant: 100),
            
            imageViewLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            imageViewLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            imageViewLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 10),
            imageViewLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -10),
        ])
    }
    @objc func buttonSwitchStatusTarget() {
        singUp.toggle()
    }
    
    private func imageViewParameters() {
        print(imageView.frame) // TODO: remove print
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTarget))
        imageView.addGestureRecognizer(tapGesture)
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.systemGray.cgColor
        imageView.layer.cornerRadius = CGFloat(75)
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
    }
    
    private func imageViewLabelParameters() {
        imageViewLabel.text = "Choose your photo of avatar"
        imageViewLabel.textColor = .systemBlue
        imageViewLabel.textAlignment = .center
        imageViewLabel.numberOfLines = 0
    }
    
    @objc func imageViewTarget() {
        navigationController?.present(phPicker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        print(picker.nibBundle?.resourceURL) // TODO: remove print
        if results.count == 1 {
            let itemProviders = results.map { $0.itemProvider }
            for item in itemProviders {
                item.loadObject(ofClass: UIImage.self) { image, error in
                    guard let image = image as? UIImage else {return}
                    DispatchQueue.main.async {
                        self.imageView.image = image
                        self.imageViewLabel.removeFromSuperview()
                    }
                }
            }
            picker.dismiss(animated: true)
        } else if results.isEmpty {
            picker.dismiss(animated: true)
        }
        else if results.count >= 2 {
            picker.showAlert("Soon", description: "Adding >1 images to Post will be adding soon", completion: nil)
            // TODO: missing dismiss?
        }
    }
}
extension AuthViewController{
   
    @objc func buttonSignTarget() {
        let name = nameField.text!
        let email = emailField.text!
        let password = passwordField.text!
        let image = imageView.image
        if singUp {
            guard let image = image else {
                showAlert(title: "Please", message: "Choose your image")
                return
            }
            if(!name.isEmpty && !email.isEmpty && !password.isEmpty) {
                
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    
                    if error == nil {
                        
                        if let result = result {
                            let avatarID = UUID().uuidString
                            guard let imageData = image.jpegData(compressionQuality: 0.3) else { return }
                            Firestore.firestore().document("\(result.user.uid)/accountInformation").setData(["name" : name, 
                                                                                                             "email": email,
                                                                                                             "avatar": avatarID])
                            StorageManager.shared.upload(id: avatarID, image: imageData)
                            print(result.user.uid) // TODO: remove print
                        }
                        self.navigationController?.pushViewController(TabBarController(), animated: true)
                    }
                }
                
            } else {
                showAlert(title: "Please", message: "Enter your textfields")
            }
        } else {
            if (!email.isEmpty && !password.isEmpty) {
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
    // TODO: use extension ViewController instead
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
}
