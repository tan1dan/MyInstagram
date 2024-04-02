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
        likeLabelParameters()
        constraints()
        bodyLabelParameters()
        buttonLookCommentParameters()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    deinit {
        bodyLabel.numberOfLines = 3
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
            likeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            likeLabel.heightAnchor.constraint(equalToConstant: 20),
            
            bodyLabel.topAnchor.constraint(equalTo: likeLabel.bottomAnchor, constant: 5),
            bodyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            bodyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            bodyLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
            
            buttonLookComments.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 5),
            buttonLookComments.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            buttonLookComments.bottomAnchor.constraint(equalTo: bottomAnchor),
            buttonLookComments.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func likeLabelParameters(){
        
    }
    
    private func bodyLabelParameters(){
        bodyLabel.numberOfLines = 3
        let gestureRecognizer = UITapGestureRecognizer()
        gestureRecognizer.addTarget(self, action: #selector(bodyLabelTarget))
        bodyLabel.addGestureRecognizer(gestureRecognizer)
        bodyLabel.isUserInteractionEnabled = true
    }
    
    @objc func bodyLabelTarget(){
        if bodyLabel.numberOfLines == 3 {
            bodyLabel.numberOfLines = 0
        } else {
            bodyLabel.numberOfLines = 3
        }
    }
    
    private func buttonLookCommentParameters(){
        buttonLookComments.setTitle("Show comments", for: .normal)
    }
}
