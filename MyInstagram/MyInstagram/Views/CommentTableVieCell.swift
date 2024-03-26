//
//  CommentTableVieCell.swift
//  MyInstagram
//
//  Created by Иван Знак on 21/03/2024.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    static let id = "CommentTableViewCell"
    
    let avatarView = UIImageView()
    let titleLabel = UILabel()
    let bodyLabel = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.numberOfLines = 0
        addSubview(avatarView)
        addSubview(titleLabel)
        addSubview(bodyLabel)
        
        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            avatarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            avatarView.heightAnchor.constraint(equalTo: avatarView.widthAnchor, multiplier: 1),
            avatarView.heightAnchor.constraint(equalToConstant: 50),
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 10),
//            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            bodyLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 10),
            bodyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            bodyLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
        ])
        
        avatarView.layer.cornerRadius = 25
        avatarView.layer.masksToBounds = true
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
