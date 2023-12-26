//
//  ViewController.swift
//  MyInstagram
//
//  Created by Иван Знак on 17/12/2023.
//

import UIKit

class ViewController: UIViewController {
    let navBarView = MainNavBarView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(navBarView)
        navBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            navBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            navBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            navBarView.heightAnchor.constraint(equalToConstant: 40)
        ])
        view.backgroundColor = .systemBackground
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        registerForTraitChanges([UITraitUserInterfaceStyle.self], handler: { (self: Self, previousTraitCollection: UITraitCollection) in
            if self.traitCollection.userInterfaceStyle == .light {
                lightMode()
                
            } else {
                darkMode()
            }
        })
        
        func lightMode(){
            self.navBarView.buttonAddPost.tintColor = .black
            self.navBarView.buttonLike.tintColor = .black
            self.navBarView.buttonMessage.tintColor = .black
            self.navBarView.label.textColor = .black
        }
        func darkMode(){
            self.navBarView.buttonAddPost.tintColor = .white
            self.navBarView.buttonLike.tintColor = .white
            self.navBarView.buttonMessage.tintColor = .white
            self.navBarView.label.textColor = .white
        }
    }
}

