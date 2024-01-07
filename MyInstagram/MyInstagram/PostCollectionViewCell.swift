//
//  PostCollectionViewCell.swift
//  MyInstagram
//
//  Created by Иван Знак on 31/12/2023.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    static let id = "PostCollectionViewCell"
    let postHeadBarView = PostHeadBarView()
    let postBottomBarView = PostBottomBarView()
    let imageView = UIImageView()
    let postCommentsView = PostCommentsView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        constraints()
        imageView.contentMode = .scaleToFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func constraints(){
        postHeadBarView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        postBottomBarView.translatesAutoresizingMaskIntoConstraints = false
        postCommentsView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(postHeadBarView)
        addSubview(imageView)
        addSubview(postBottomBarView)
        addSubview(postCommentsView)
        
        NSLayoutConstraint.activate([
            postHeadBarView.topAnchor.constraint(equalTo: topAnchor),
            postHeadBarView.trailingAnchor.constraint(equalTo: trailingAnchor),
            postHeadBarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            postHeadBarView.heightAnchor.constraint(equalToConstant: 40),
            
            imageView.topAnchor.constraint(equalTo: postHeadBarView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            postBottomBarView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            postBottomBarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            postBottomBarView.trailingAnchor.constraint(equalTo: trailingAnchor),
            postBottomBarView.heightAnchor.constraint(equalToConstant: 40),
            
            postCommentsView.topAnchor.constraint(equalTo: postBottomBarView.bottomAnchor),
            postCommentsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            postCommentsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            postCommentsView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
