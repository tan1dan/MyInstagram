//
//  PostCommentsView.swift
//  MyInstagram
//
//  Created by Иван Знак on 02/01/2024.
//

import UIKit

class PostCommentsView: UIView {
    
    let bodyLabel = UILabel()
    let likeLabel = UILabel()
    let buttonLookComments = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        constraints()
        likeLabelParameters()
        bodyLabelParameters()
        buttonLookCommentParameters()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    private func constraints(){
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        likeLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonLookComments.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(bodyLabel)
        addSubview(likeLabel)
        addSubview(buttonLookComments)
        
        NSLayoutConstraint.activate([
            likeLabel.topAnchor.constraint(equalTo: topAnchor),
            likeLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            likeLabel.heightAnchor.constraint(equalToConstant: 20),
            
            bodyLabel.topAnchor.constraint(equalTo: likeLabel.bottomAnchor, constant: 5),
            bodyLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            bodyLabel.heightAnchor.constraint(equalToConstant: 20),
            
            buttonLookComments.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 5),
            buttonLookComments.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonLookComments.bottomAnchor.constraint(equalTo: bottomAnchor),
            buttonLookComments.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func likeLabelParameters(){
        likeLabel.text = "Likes: 1000"
    }
    
    private func bodyLabelParameters(){
        bodyLabel.text = "Big body test text pmspamp"
    }
    
    private func buttonLookCommentParameters(){
        buttonLookComments.setTitle("Show comments", for: .normal)
    }
}
