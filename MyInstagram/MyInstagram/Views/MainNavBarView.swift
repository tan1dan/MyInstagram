//
//  MainNavBarView.swift
//  MyInstagram
//
//  Created by Иван Знак on 25/12/2023.
//

import UIKit

protocol MainBarViewDelegate: AnyObject {
    func buttonAddPostPressed(_ sender: MainNavBarView)
    func buttonLikePressed(_ sender: MainNavBarView)
    func buttonMessagePressed(_ sender: MainNavBarView)
}

class MainNavBarView: UIView {
    
    let label = UILabel()
    let buttonAddPost = UIButton(type: .system)
    let buttonLike = UIButton(type: .system)
    let buttonMessage = UIButton(type: .system)
    weak var delegate: MainBarViewDelegate?
    
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
        buttonMessage.addTarget(self, action: #selector(buttonMessageTapped), for: .touchUpInside)
        
        buttonLike.setImage(UIImage(systemName: "heart"), for: .normal)
        buttonLike.tintColor = .black
        buttonLike.contentVerticalAlignment = .fill
        buttonLike.contentHorizontalAlignment = .fill
        buttonLike.contentMode = .scaleAspectFill
        buttonLike.addTarget(self, action: #selector(buttonLikeTapped), for: .touchUpInside)
        
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
    @objc func buttonLikeTapped(){
        delegate?.buttonLikePressed(self)
    }
    @objc func buttonMessageTapped(){
        delegate?.buttonMessagePressed(self)
    }
    
    func lightMode(){
        buttonAddPost.tintColor = .black
        buttonLike.tintColor = .black
        buttonMessage.tintColor = .black
        label.textColor = .black
    }
    func darkMode(){
        buttonAddPost.tintColor = .white
        buttonLike.tintColor = .white
        buttonMessage.tintColor = .white
        label.textColor = .white
    }
}
