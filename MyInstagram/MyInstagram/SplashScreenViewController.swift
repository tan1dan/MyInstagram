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
        view.backgroundColor = .systemBackground
        logoViewParameters()
    }
    
    private func logoViewParameters(){
        logoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoView)
        NSLayoutConstraint.activate([
            logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            logoView.heightAnchor.constraint(equalTo: logoView.widthAnchor, multiplier: 1),
            logoView.heightAnchor.constraint(equalToConstant: 150)
        ])
        let nextVC = ViewController()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            self.navigationController?.pushViewController(nextVC, animated: false)
        }
        logoView.image = UIImage(resource: .logo1)
    }
}
