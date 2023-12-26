//
//  MainNavBarView.swift
//  MyInstagram
//
//  Created by Иван Знак on 25/12/2023.
//

import UIKit

class MainNavBarView: UIView {
    
    let label = UILabel()
    let buttonAddPost = UIButton()
    let buttonLike = UIButton()
    let buttonMessage = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        constraints()
        buttonParameters()
        labelParameters()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func constraints(){
        addSubview(label)
        addSubview(buttonLike)
        addSubview(buttonMessage)
        addSubview(buttonAddPost)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        buttonLike.translatesAutoresizingMaskIntoConstraints = false
        buttonMessage.translatesAutoresizingMaskIntoConstraints = false
        buttonAddPost.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            //Label
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.widthAnchor.constraint(equalToConstant: 200),
            
            //ButtonMessage
            buttonMessage.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttonMessage.topAnchor.constraint(equalTo: topAnchor, constant: 7),
            buttonMessage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7),
            buttonMessage.heightAnchor.constraint(equalTo: buttonMessage.widthAnchor, multiplier: 1),
            
            //ButtonLike
            buttonLike.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            buttonLike.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            buttonLike.trailingAnchor.constraint(equalTo: buttonMessage.leadingAnchor, constant: -20),
            buttonLike.heightAnchor.constraint(equalTo: buttonLike.widthAnchor, multiplier: 1/1.15),
            
            //ButtonAddPost
            buttonAddPost.topAnchor.constraint(equalTo: topAnchor, constant: 7),
            buttonAddPost.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7),
            buttonAddPost.trailingAnchor.constraint(equalTo: buttonLike.leadingAnchor, constant: -20),
            buttonAddPost.heightAnchor.constraint(equalTo: buttonAddPost.widthAnchor, multiplier: 1)
        ])
    }
    
    func buttonParameters(){
        buttonMessage.setImage(UIImage(systemName: "message"), for: .normal)
        buttonMessage.tintColor = .black
        buttonMessage.contentVerticalAlignment = .fill
        buttonMessage.contentHorizontalAlignment = .fill
        buttonMessage.contentMode = .scaleAspectFill
        
        buttonLike.setImage(UIImage(systemName: "heart"), for: .normal)
        buttonLike.tintColor = .black
        buttonLike.contentVerticalAlignment = .fill
        buttonLike.contentHorizontalAlignment = .fill
        buttonLike.contentMode = .scaleAspectFill
        
        buttonAddPost.setImage(UIImage(systemName: "plus.viewfinder"), for: .normal)
        buttonAddPost.tintColor = .black
        buttonAddPost.contentVerticalAlignment = .fill
        buttonAddPost.contentHorizontalAlignment = .fill
        buttonAddPost.contentMode = .scaleAspectFill
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
}
