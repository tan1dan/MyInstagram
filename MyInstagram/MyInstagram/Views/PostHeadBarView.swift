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
    let optionsButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        constraints()
        authorAvatarParameters()
        authorLabelParameters()
        optionsButtonParameters()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        authorAvatar.layer.cornerRadius = CGFloat(authorAvatar.frame.size.width / 2)
        authorAvatar.layer.masksToBounds = true
        addTopBorder(color: .gray, thickness: 0.5)
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
            authorAvatar.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            authorAvatar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            authorAvatar.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            authorAvatar.heightAnchor.constraint(equalTo: authorAvatar.widthAnchor, multiplier: 1),
            
            authorLabel.leadingAnchor.constraint(equalTo: authorAvatar.trailingAnchor, constant: 10),
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
        
        print(CGFloat(authorAvatar.frame.width / 2))
        authorAvatar.contentMode = .scaleToFill
    }
    
    private func authorLabelParameters(){
        authorLabel.font = .systemFont(ofSize: UIFont.systemFontSize + 1, weight: .bold)
    }
    
    private func optionsButtonParameters(){
        optionsButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
    }
    
    private func addTopBorder(color: UIColor, thickness: CGFloat) {
            let topBorder = CALayer()
            topBorder.backgroundColor = color.cgColor
            topBorder.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: thickness)
            layer.addSublayer(topBorder)
    }
}
