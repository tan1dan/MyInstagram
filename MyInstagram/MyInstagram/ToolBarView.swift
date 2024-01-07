//
//  ToolBarView.swift
//  MyInstagram
//
//  Created by Иван Знак on 07/01/2024.
//

import UIKit

class ToolBarView: UIView {
    let buttonHome = UIButton()
    let buttonSearch = UIButton()
    let buttonAddPost = UIButton()
    let buttonMedia = UIButton()
    let buttonAccount = UIButton()
    let stackView = UIStackView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        buttonParameters()
        stackViewParameters()
        
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
        super.init(coder: coder)
        fatalError("Required init")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        buttonAccount.imageView?.layer.cornerRadius = CGFloat(((buttonAccount.imageView?.frame.width ?? 0) / 2))
        addTopBorder(color: .gray, thickness: 0.5)
    }
    
    private func addSubviews(){
        buttonHome.translatesAutoresizingMaskIntoConstraints = false
        buttonSearch.translatesAutoresizingMaskIntoConstraints = false
        buttonAddPost.translatesAutoresizingMaskIntoConstraints = false
        buttonMedia.translatesAutoresizingMaskIntoConstraints = false
        buttonAccount.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        stackView.addArrangedSubview(buttonHome)
        stackView.addArrangedSubview(buttonSearch)
        stackView.addArrangedSubview(buttonAddPost)
        stackView.addArrangedSubview(buttonMedia)
        stackView.addArrangedSubview(buttonAccount)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            
            buttonAccount.heightAnchor.constraint(equalTo: buttonAccount.widthAnchor, multiplier: 1),
            buttonAccount.topAnchor.constraint(equalTo: topAnchor, constant: 9),
            buttonAccount.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -9),
            
            buttonHome.heightAnchor.constraint(equalTo: buttonHome.widthAnchor, multiplier: 1/1.15),
            buttonHome.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            buttonHome.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            buttonAddPost.heightAnchor.constraint(equalTo: buttonAddPost.widthAnchor, multiplier: 1),
            buttonAddPost.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            buttonAddPost.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            buttonMedia.heightAnchor.constraint(equalTo: buttonMedia.widthAnchor, multiplier: 1/1.1),
            buttonMedia.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            buttonMedia.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            buttonSearch.heightAnchor.constraint(equalTo: buttonSearch.widthAnchor, multiplier: 1/1.1),
            buttonSearch.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            buttonSearch.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
        ])
    }
    
    private func stackViewParameters(){
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
    }
    
    private func buttonParameters(){
        buttonHome.setImage(UIImage(systemName: "house"), for: .normal)
        buttonHome.contentVerticalAlignment = .fill
        buttonHome.contentHorizontalAlignment = .fill
        
        buttonSearch.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        buttonSearch.contentVerticalAlignment = .fill
        buttonSearch.contentHorizontalAlignment = .fill
        
        buttonAddPost.setImage(UIImage(systemName: "plus.viewfinder"), for: .normal)
        buttonAddPost.contentVerticalAlignment = .fill
        buttonAddPost.contentHorizontalAlignment = .fill
        
        buttonMedia.setImage(UIImage(systemName: "play.square"), for: .normal)
        buttonMedia.contentVerticalAlignment = .fill
        buttonMedia.contentHorizontalAlignment = .fill
        
        buttonAccount.setImage(UIImage(resource: .avatar1), for: .normal)
    }
    
    private func addTopBorder(color: UIColor, thickness: CGFloat) {
            let topBorder = CALayer()
            topBorder.backgroundColor = color.cgColor
            topBorder.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: thickness)
            layer.addSublayer(topBorder)
    }
    
    private func lightMode(){
        buttonHome.tintColor = .black
        buttonSearch.tintColor = .black
        buttonAddPost.tintColor = .black
        buttonMedia.tintColor = .black
    }
    
    private func darkMode(){
        buttonHome.tintColor = .white
        buttonSearch.tintColor = .white
        buttonAddPost.tintColor = .white
        buttonMedia.tintColor = .white
    }
}
