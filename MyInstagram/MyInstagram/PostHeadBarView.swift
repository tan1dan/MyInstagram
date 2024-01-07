//
//  PostHeadBarView.swift
//  MyInstagram
//
//  Created by Иван Знак on 31/12/2023.
//

import UIKit

class PostHeadBarView: UIView {
    
    let authorAvatar = UIImageView()
    let authorLabel = UILabel()
    let optionsButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        constraints()
        authorAvatarParameters()
        authorLabelParameters()
        optionsButtonParameters()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        authorAvatarParameters()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func constraints(){
        authorAvatar.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        optionsButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(authorAvatar)
        addSubview(authorLabel)
        addSubview(optionsButton)
        
        NSLayoutConstraint.activate([
            authorAvatar.topAnchor.constraint(equalTo: topAnchor),
            authorAvatar.leadingAnchor.constraint(equalTo: leadingAnchor),
            authorAvatar.bottomAnchor.constraint(equalTo: bottomAnchor),
            authorAvatar.heightAnchor.constraint(equalTo: authorAvatar.widthAnchor, multiplier: 1),
            
            authorLabel.leadingAnchor.constraint(equalTo: authorAvatar.trailingAnchor, constant: 5),
            authorLabel.topAnchor.constraint(equalTo: topAnchor),
            authorLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            optionsButton.topAnchor.constraint(equalTo: topAnchor),
            optionsButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            optionsButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            optionsButton.heightAnchor.constraint(equalTo: optionsButton.widthAnchor, multiplier: 1)
        ])
    }
    
    private func authorAvatarParameters(){
        authorAvatar.image = UIImage(resource: .avatar1)
        authorAvatar.layer.cornerRadius = CGFloat(authorAvatar.frame.width / 2)
        authorAvatar.contentMode = .scaleAspectFit
    }
    
    private func authorLabelParameters(){
        
    }
    
    private func optionsButtonParameters(){
        optionsButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        optionsButton.tintColor = .systemBackground
    }
}
