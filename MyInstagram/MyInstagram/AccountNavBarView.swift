//
//  AccountNavViewBar.swift
//  MyInstagram
//
//  Created by Иван Знак on 11/01/2024.
//

import UIKit

protocol AccountNavBarViewDelegate: AnyObject {
    func buttonAddPostPressed(_ sender: AccountNavViewBar)
    func buttonParameterPressed(_ sender: AccountNavViewBar)
}

class AccountNavViewBar: UIView {
    let label = UILabel()
    let buttonAddPost = UIButton(type: .system)
    let buttonParameter = UIButton(type: .system)
    weak var delegate: AccountNavBarViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        constraints()
        buttonParameters()
        labelParameters()
        if self.traitCollection.userInterfaceStyle == .light {
            lightMode()
            
        } else {
            darkMode()
        }
        registerForTraitChanges([UITraitUserInterfaceStyle.self], handler: { (self: Self, previousTraitCollection: UITraitCollection) in
            if self.traitCollection.userInterfaceStyle == .light {
                self.lightMode()
                
            } else {
                self.darkMode()
            }
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func constraints(){
        addSubview(label)
        addSubview(buttonParameter)
        addSubview(buttonAddPost)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        buttonParameter.translatesAutoresizingMaskIntoConstraints = false
        buttonAddPost.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            //Label
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.widthAnchor.constraint(equalToConstant: 200),
            
            //ButtonLike
            buttonParameter.topAnchor.constraint(equalTo: topAnchor, constant: 7),
            buttonParameter.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7),
            buttonParameter.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            buttonParameter.heightAnchor.constraint(equalTo: buttonParameter.widthAnchor, multiplier: 1),
            
            //ButtonAddPost
            buttonAddPost.topAnchor.constraint(equalTo: topAnchor, constant: 7),
            buttonAddPost.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7),
            buttonAddPost.trailingAnchor.constraint(equalTo: buttonParameter.leadingAnchor, constant: -20),
            buttonAddPost.heightAnchor.constraint(equalTo: buttonAddPost.widthAnchor, multiplier: 1)
        ])
    }
    
    func buttonParameters(){
        
        buttonParameter.setImage(UIImage(systemName: "line.3.horizontal"), for: .normal)
        buttonParameter.tintColor = .black
        buttonParameter.contentVerticalAlignment = .fill
        buttonParameter.contentHorizontalAlignment = .fill
        buttonParameter.contentMode = .scaleAspectFill
        buttonParameter.addTarget(self, action: #selector(buttonParameterTapped), for: .touchUpInside)
        
        buttonAddPost.setImage(UIImage(systemName: "plus.viewfinder"), for: .normal)
        buttonAddPost.tintColor = .black
        buttonAddPost.contentVerticalAlignment = .fill
        buttonAddPost.contentHorizontalAlignment = .fill
        buttonAddPost.contentMode = .scaleAspectFill
        buttonAddPost.addTarget(self, action: #selector(buttonAddPostTapped), for: .touchUpInside)
        
    }
    
    func labelParameters(){
        label.text = "Instagram"
//        for family in UIFont.familyNames.sorted(){
//            let names = UIFont.fontNames(forFamilyName: family)
//            print("Family: \(family), names: \(names)")
//        }
        if let lobsterFont = UIFont(name: "Lobster-Regular", size: 26.0) {
            label.font = lobsterFont
        }
    }
    
    @objc func buttonAddPostTapped(){
        delegate?.buttonAddPostPressed(self)
    }
    @objc func buttonParameterTapped(){
        delegate?.buttonParameterPressed(self)
    }

    
    func lightMode(){
        buttonAddPost.tintColor = .black
        buttonParameter.tintColor = .black
        label.textColor = .black
    }
    func darkMode(){
        buttonAddPost.tintColor = .white
        buttonParameter.tintColor = .white
        label.textColor = .white
    }
}
