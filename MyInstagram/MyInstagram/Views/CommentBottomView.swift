//
//  CommentBottomView.swift
//  MyInstagram
//
//  Created by Иван Знак on 21/03/2024.
//

import UIKit

class CommentBottomView: UIView {
    
    let avatarImageView = UIImageView()
    let commentField = UITextField()
    let buttonSend = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        commentField.translatesAutoresizingMaskIntoConstraints = false
        buttonSend.translatesAutoresizingMaskIntoConstraints = false
        addSubview(avatarImageView)
        addSubview(commentField)
        addSubview(buttonSend)
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            avatarImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor, multiplier: 1),
            
            commentField.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            commentField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            commentField.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 15),
            
            buttonSend.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            buttonSend.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            buttonSend.leadingAnchor.constraint(equalTo: commentField.trailingAnchor, constant: 5),
            buttonSend.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            buttonSend.widthAnchor.constraint(equalToConstant: 42),
        ])
        
        commentField.placeholder = "Leave a comment..."
        buttonSend.setImage(UIImage(systemName: "chevron.up.square.fill"), for: .normal)
        buttonSend.tintColor = .systemBlue
        buttonSend.contentHorizontalAlignment = .fill
        buttonSend.contentVerticalAlignment = .fill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
