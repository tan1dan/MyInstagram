//
//  StoryCollectionViewCell.swift
//  MyInstagram
//
//  Created by Иван Знак on 27/12/2023.
//

import UIKit

class StoryCollectionViewCell: UICollectionViewCell {
    static let id = "storyCollectionViewCell"
    let avatarView = UIImageView()
    let backgroundLayer = CAGradientLayer()
    let nicknameLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        constraints()
        avatarViewParameters()
        backgroundLayerParameters()
        nicknameLabelParameters()
    }
    override func layoutSubviews(){
        super.layoutSubviews()
        if backgroundLayer.superlayer == nil {
            layer.addSublayer(backgroundLayer)
            layer.addSublayer(avatarView.layer)
        }
        avatarViewParameters()
        backgroundLayerParameters()
        nicknameLabelParameters()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func constraints(){
        addSubview(avatarView)
        addSubview(nicknameLabel)
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            avatarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            avatarView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            avatarView.heightAnchor.constraint(equalTo: avatarView.widthAnchor, multiplier: 1),
            
            nicknameLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 5),
            nicknameLabel.leadingAnchor.constraint(equalTo: avatarView.leadingAnchor),
            nicknameLabel.trailingAnchor.constraint(equalTo: avatarView.trailingAnchor),
            nicknameLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func avatarViewParameters(){
        avatarView.image = UIImage(resource: .avatar1)
        avatarView.clipsToBounds = true
        avatarView.contentMode = .scaleToFill
        avatarView.layer.borderColor = UIColor.systemBackground.cgColor
        avatarView.layer.borderWidth = 3
        avatarView.layer.cornerRadius = CGFloat(avatarView.frame.size.width / 2)
    }
    
    private func backgroundLayerParameters(){
        backgroundLayer.frame = CGRect(x: avatarView.frame.origin.x, y: avatarView.frame.origin.y, width: avatarView.frame.width + 5, height: avatarView.frame.height + 5)
        backgroundLayer.cornerRadius = CGFloat(avatarView.frame.width / 2)
        
        let centerX = avatarView.frame.origin.x + avatarView.bounds.width / 2
        let centerY = avatarView.frame.origin.y + avatarView.bounds.height / 2
        backgroundLayer.position = CGPoint(x: centerX, y: centerY)
        
        let redColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        let orangeColor = UIColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 1.0)
        let yellowColor = UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0)
        let purpleColor = UIColor(red: 0.5, green: 0.0, blue: 0.5, alpha: 1.0)

        backgroundLayer.colors = [redColor.cgColor, orangeColor.cgColor, yellowColor.cgColor, purpleColor.cgColor]
        backgroundLayer.startPoint = CGPoint(x: 0, y: 0)
        backgroundLayer.endPoint = CGPoint(x: 1, y: 0)
    }
    
    private func nicknameLabelParameters(){
        nicknameLabel.textAlignment = .center
        nicknameLabel.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        nicknameLabel.setContentHuggingPriority(UILayoutPriority(1000), for: .vertical)
    }
}
