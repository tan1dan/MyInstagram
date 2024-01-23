//
//  MainAccountView.swift
//  MyInstagram
//
//  Created by Иван Знак on 12/01/2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class MainAccountView: UIView {
    
    let avatarImageView = UIImageView()
    let nameLabel = UILabel()
    let labelPosts = UILabel()
    let labelNumberOfPosts = UILabel()
    let labelSubscribers = UILabel()
    let labelNumberOfSubscribers = UILabel()
    let labelSubscribes = UILabel()
    let labelNumberOfSubscribes = UILabel()
    
    let avatarStackView = UIStackView()
    let postsStackView = UIStackView()
    let subscribersStackView = UIStackView()
    let subscribesStackView = UIStackView()
    let mainStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        constraints()
        stackViewParameters()
        labelsParameters()
        imageViewParameters()
        print(avatarImageView.layer.frame.size.width)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        defer { print(avatarImageView.layer.frame.size.width)}
        print(avatarImageView.layer.frame.size.width)
        avatarImageView.layer.cornerRadius = CGFloat(avatarImageView.layer.bounds.size.width / 2)
        avatarImageView.layer.masksToBounds = true
        
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        print(avatarImageView.layer.frame.size.width)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    private func constraints(){
        addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(avatarStackView)
        mainStackView.addArrangedSubview(postsStackView)
        mainStackView.addArrangedSubview(subscribersStackView)
        mainStackView.addArrangedSubview(subscribesStackView)
        
        avatarStackView.addArrangedSubview(avatarImageView)
        avatarStackView.addArrangedSubview(nameLabel)
       
        postsStackView.addArrangedSubview(labelNumberOfPosts)
        postsStackView.addArrangedSubview(labelPosts)
        
        subscribersStackView.addArrangedSubview(labelNumberOfSubscribers)
        subscribersStackView.addArrangedSubview(labelSubscribers)
        
        subscribesStackView.addArrangedSubview(labelNumberOfSubscribes)
        subscribesStackView.addArrangedSubview(labelSubscribes)
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        labelPosts.translatesAutoresizingMaskIntoConstraints = false
        labelNumberOfPosts.translatesAutoresizingMaskIntoConstraints = false
        labelSubscribers.translatesAutoresizingMaskIntoConstraints = false
        labelNumberOfSubscribers.translatesAutoresizingMaskIntoConstraints = false
        labelSubscribes.translatesAutoresizingMaskIntoConstraints = false
        labelNumberOfSubscribes.translatesAutoresizingMaskIntoConstraints = false
        avatarStackView.translatesAutoresizingMaskIntoConstraints = false
        postsStackView.translatesAutoresizingMaskIntoConstraints = false
        subscribersStackView.translatesAutoresizingMaskIntoConstraints = false
        subscribesStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor, multiplier: 1),
        ])
        
    }
    
    private func stackViewParameters(){
        mainStackView.axis = .horizontal
        mainStackView.distribution = .fillEqually
        avatarStackView.axis = .vertical
        avatarStackView.distribution = .equalSpacing
        
        postsStackView.axis = .vertical
        postsStackView.distribution = .fillProportionally
        subscribersStackView.axis = .vertical
        subscribersStackView.distribution = .fillProportionally
        subscribesStackView.axis = .vertical
        subscribesStackView.distribution = .fillProportionally
    }
    
    private func labelsParameters(){
        if let id = Auth.auth().currentUser?.uid {
            Firestore.firestore().document("\(id)/accountInformation").getDocument { snapshot, error in
                if error == nil {
                    if let snapshot = snapshot?.data() {
                        self.nameLabel.text = snapshot["name"] as? String
                    }
                }
            }
        }
        labelPosts.text = "Posts"
        labelPosts.textAlignment = .center
        labelNumberOfPosts.text = "0"
        labelNumberOfPosts.textAlignment = .center
        
        labelSubscribers.text = "Subscribers"
        labelSubscribers.textAlignment = .center
        labelNumberOfSubscribers.text = "0"
        labelNumberOfSubscribers.textAlignment = .center
        
        labelSubscribes.text = "Subscribes"
        labelSubscribes.textAlignment = .center
        labelNumberOfSubscribes.text = "0"
        labelNumberOfSubscribes.textAlignment = .center
    }
    
    private func imageViewParameters(){
        avatarImageView.image = UIImage(resource: .avatar1)
    }
}
