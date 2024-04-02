//
//  PostCollectionViewCell.swift
//  MyInstagram
//
//  Created by Иван Знак on 31/12/2023.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    static let id = "PostCollectionViewCell"
    var postId = "Yuhuu"
    let postHeadBarView = PostHeadBarView()
    let postBottomBarView = PostBottomBarView()
    let imageView = UIImageView()
    let postCommentsView = PostCommentsView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        constraints()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
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
            postHeadBarView.heightAnchor.constraint(equalToConstant: 50),
            
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
    
    private func lightMode(){
        postHeadBarView.optionsButton.tintColor = .black
        postHeadBarView.authorLabel.textColor = .black
        postBottomBarView.buttonLike.tintColor = .black
        postBottomBarView.buttonComment.tintColor = .black
        postBottomBarView.buttonSend.tintColor = .black
        postBottomBarView.buttonBookmarks.tintColor = .black
        postCommentsView.buttonLookComments.tintColor = .systemGray
        postCommentsView.likeLabel.textColor = .black
        postCommentsView.bodyLabel.textColor = .black
        
    }
    private func darkMode(){
        postHeadBarView.optionsButton.tintColor = .white
        postHeadBarView.authorLabel.textColor = .white
        postBottomBarView.buttonLike.tintColor = .white
        postBottomBarView.buttonComment.tintColor = .white
        postBottomBarView.buttonSend.tintColor = .white
        postBottomBarView.buttonBookmarks.tintColor = .white
        postCommentsView.buttonLookComments.tintColor = .systemGray
        postCommentsView.likeLabel.textColor = .white
        postCommentsView.bodyLabel.textColor = .white
    }
}
