//
//  SplashViewController.swift
//  MyInstagram
//
//  Created by Иван Знак on 17/12/2023.
//

import UIKit
import Firebase
import FirebaseCore

class SplashScreenViewController: UIViewController {
    
    let logoView = UIImageView()
    let nextVC = ViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var nextVC: UIViewController = UIViewController()
        view.backgroundColor = .systemBackground
        logoViewParameters()
        Auth.auth().addStateDidChangeListener { auth, user in
            if user == nil {
                nextVC = AuthViewController()
            }
            else {
                nextVC = TabBarController()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.navigationController?.pushViewController(nextVC, animated: false)
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }
   
    private func logoViewParameters() {
        logoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoView)
        NSLayoutConstraint.activate([
            logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            logoView.heightAnchor.constraint(equalTo: logoView.widthAnchor, multiplier: 1),
            logoView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        logoView.image = UIImage(resource: .logo1)
    }
}
