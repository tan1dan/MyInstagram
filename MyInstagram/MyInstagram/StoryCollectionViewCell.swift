//
//  StoryCollectionViewCell.swift
//  MyInstagram
//
//  Created by Иван Знак on 27/12/2023.
//

import UIKit

class StoryCollectionViewCell: UICollectionViewCell {
    let avatarView = UIImageView()
    let backgroundLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        constraints()
        avatarViewParameters()
        backgroundLayerParameters()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func constraints(){
        addSubview(avatarView)
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: topAnchor),
            avatarView.bottomAnchor.constraint(equalTo: bottomAnchor),
            avatarView.leadingAnchor.constraint(equalTo: leadingAnchor),
            avatarView.trailingAnchor.constraint(equalTo: trailingAnchor),
            avatarView.heightAnchor.constraint(equalTo: avatarView.widthAnchor, multiplier: 1)
        ])
    }
    
    func avatarViewParameters(){
        avatarView.image = UIImage(resource: .avatar)
        avatarView.layer.cornerRadius = avatarView.frame.size.width / 2
        avatarView.clipsToBounds = true
    }
    
    func backgroundLayerParameters(){
        backgroundLayer.frame = avatarView.bounds
        backgroundLayer.cornerRadius = backgroundLayer.frame.width / 2
        
        let redColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        let orangeColor = UIColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 1.0)
        let yellowColor = UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0)
        let purpleColor = UIColor(red: 0.5, green: 0.0, blue: 0.5, alpha: 1.0)

        backgroundLayer.colors = [redColor, orangeColor, yellowColor, purpleColor]
        backgroundLayer.startPoint = CGPoint(x: 0, y: 0)
        backgroundLayer.endPoint = CGPoint(x: 1, y: 0)
        layer.addSublayer(backgroundLayer)
    }
}
