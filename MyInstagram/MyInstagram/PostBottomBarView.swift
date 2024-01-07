//
//  PostBottomBarView.swift
//  MyInstagram
//
//  Created by Иван Знак on 31/12/2023.
//

import UIKit

class PostBottomBarView: UIView {
    
    let buttonLike = UIButton()
    let buttonComment = UIButton()
    let buttonSend = UIButton()
    let buttonBookmarks = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        constraints()
        buttonsParameters()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func constraints(){
        
        buttonLike.translatesAutoresizingMaskIntoConstraints = false
        buttonComment.translatesAutoresizingMaskIntoConstraints = false
        buttonSend.translatesAutoresizingMaskIntoConstraints = false
        buttonBookmarks.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(buttonLike)
        addSubview(buttonComment)
        addSubview(buttonSend)
        addSubview(buttonBookmarks)
        
        NSLayoutConstraint.activate([
            buttonLike.topAnchor.constraint(equalTo: topAnchor),
            buttonLike.bottomAnchor.constraint(equalTo: bottomAnchor),
            buttonLike.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonLike.heightAnchor.constraint(equalTo: buttonLike.widthAnchor, multiplier: 1),
            
            buttonComment.topAnchor.constraint(equalTo: topAnchor),
            buttonComment.bottomAnchor.constraint(equalTo: bottomAnchor),
            buttonComment.leadingAnchor.constraint(equalTo: buttonLike.trailingAnchor, constant: 5),
            buttonComment.heightAnchor.constraint(equalTo: buttonComment.widthAnchor, multiplier: 1),
            
            buttonSend.topAnchor.constraint(equalTo: topAnchor),
            buttonSend.bottomAnchor.constraint(equalTo: bottomAnchor),
            buttonSend.leadingAnchor.constraint(equalTo: buttonComment.trailingAnchor, constant: 5),
            buttonSend.heightAnchor.constraint(equalTo: buttonSend.widthAnchor, multiplier: 1),
            
            buttonBookmarks.topAnchor.constraint(equalTo: topAnchor),
            buttonBookmarks.bottomAnchor.constraint(equalTo: bottomAnchor),
            buttonBookmarks.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttonBookmarks.heightAnchor.constraint(equalTo: buttonBookmarks.widthAnchor, multiplier: 1)
        ])
    }
    private func buttonsParameters(){
        buttonLike.setImage(UIImage(systemName: "heart"), for: .normal)
        buttonComment.setImage(UIImage(systemName: "message"), for: .normal)
        buttonSend.setImage(UIImage(systemName: "paperplane"), for: .normal)
        buttonBookmarks.setImage(UIImage(systemName: "bookmark"), for: .normal)
    }
}
