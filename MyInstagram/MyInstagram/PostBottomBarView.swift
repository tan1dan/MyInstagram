//
//  PostBottomBarView.swift
//  MyInstagram
//
//  Created by Иван Знак on 31/12/2023.
//

import UIKit

protocol PostBottomBarViewDelegate: AnyObject {
    func buttonLikePres(_ sender: PostBottomBarView)
    func buttonBookmark(_ sender: PostBottomBarView)
}


class PostBottomBarView: UIView {
    
    let buttonLike = UIButton(type: .system)
    let buttonComment = UIButton(type: .system)
    let buttonSend = UIButton(type: .system)
    let buttonBookmarks = UIButton(type: .system)
    var isBookmark = false
    weak var delegate: PostBottomBarViewDelegate?
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
            buttonLike.topAnchor.constraint(equalTo: topAnchor, constant: 7.5),
            buttonLike.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7.5),
            buttonLike.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            buttonLike.heightAnchor.constraint(equalTo: buttonLike.widthAnchor, multiplier: 1/1.15),
            
            buttonComment.topAnchor.constraint(equalTo: topAnchor, constant: 7),
            buttonComment.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7),
            buttonComment.leadingAnchor.constraint(equalTo: buttonLike.trailingAnchor, constant: 15),
            buttonComment.heightAnchor.constraint(equalTo: buttonComment.widthAnchor, multiplier: 1),
            
            buttonSend.topAnchor.constraint(equalTo: topAnchor, constant: 7),
            buttonSend.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7),
            buttonSend.leadingAnchor.constraint(equalTo: buttonComment.trailingAnchor, constant: 15),
            buttonSend.heightAnchor.constraint(equalTo: buttonSend.widthAnchor, multiplier: 1),
            
            buttonBookmarks.topAnchor.constraint(equalTo: topAnchor, constant: 7),
            buttonBookmarks.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7),
            buttonBookmarks.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            buttonBookmarks.heightAnchor.constraint(equalTo: buttonBookmarks.widthAnchor, multiplier: 1)
        ])
    }
    private func buttonsParameters(){
        buttonLike.setImage(UIImage(systemName: "heart"), for: .normal)
        buttonComment.setImage(UIImage(systemName: "message"), for: .normal)
        buttonSend.setImage(UIImage(systemName: "paperplane"), for: .normal)
        buttonBookmarks.setImage(UIImage(systemName: "bookmark"), for: .normal)
        
        buttonLike.contentVerticalAlignment = .fill
        buttonLike.contentHorizontalAlignment = .fill
        buttonLike.addTarget(self, action: #selector(buttonLikeTarget), for: .touchUpInside)
        
        buttonComment.contentVerticalAlignment = .fill
        buttonComment.contentHorizontalAlignment = .fill
        
        buttonSend.contentVerticalAlignment = .fill
        buttonSend.contentHorizontalAlignment = .fill
        
        buttonBookmarks.contentVerticalAlignment = .fill
        buttonBookmarks.contentHorizontalAlignment = .fill
        buttonBookmarks.addTarget(self, action: #selector(buttonBookmarkTarget), for: .touchUpInside)
    }
    
    @objc func buttonLikeTarget(){
        delegate?.buttonLikePres(self)
    }
    
    @objc func buttonBookmarkTarget(){
        if !isBookmark {
            UIView.animate(withDuration: 0.2, animations: {
                self.buttonBookmarks.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                let scaleTransform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                self.buttonBookmarks.transform = scaleTransform
            }){ _ in
                UIView.animate(withDuration: 0.2) {
                    self.buttonBookmarks.transform = CGAffineTransform.identity
                }
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.buttonBookmarks.setImage(UIImage(systemName: "bookmark"), for: .normal)
            }
        }
        delegate?.buttonBookmark(self)
        isBookmark.toggle()
    }
    
}
