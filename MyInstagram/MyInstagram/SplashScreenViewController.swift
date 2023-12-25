//
//  SplashViewController.swift
//  MyInstagram
//
//  Created by Иван Знак on 17/12/2023.
//

import UIKit

class SplashScreenViewController: UIViewController {
    
    let logoView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoViewParameters()
    }
    
    private func logoViewParameters(){
        logoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoView)
        logoView.heightAnchor.constraint(equalTo: logoView.widthAnchor, multiplier: 1, constant: 50).isActive = true
//        NSLayoutConstraint.activate([
//            logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            logoView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
//            logoView.heightAnchor.constraint(equalTo: logoView.widthAnchor, multiplier: 1, constant: 1)
//        ])
        logoView.contentMode = .scaleAspectFit
        logoView.image = UIImage(resource: .logo)
    }
}
