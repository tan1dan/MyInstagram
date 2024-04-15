//
//  MainAccountViewUpdate.swift
//  MyInstagram
//
//  Created by Иван Знак on 09/03/2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class MainAccountViewUpdate: UIView {
    
    let avatarImageView = UIImageView()
    let nameLabel = UILabel()
    
    let labelsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let labelPosts = UILabel()
    let labelNumberOfPosts = UILabel()
    let labelSubscribers = UILabel()
    let labelNumberOfSubscribers = UILabel()
    let labelSubscribes = UILabel()
    let labelNumberOfSubscribes = UILabel()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        constraints()
        labelsParameters()
        imageViewParameters()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    private func constraints(){
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        labelPosts.translatesAutoresizingMaskIntoConstraints = false
        labelNumberOfPosts.translatesAutoresizingMaskIntoConstraints = false
        labelSubscribers.translatesAutoresizingMaskIntoConstraints = false
        labelNumberOfSubscribers.translatesAutoresizingMaskIntoConstraints = false
        labelSubscribes.translatesAutoresizingMaskIntoConstraints = false
        labelNumberOfSubscribes.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(avatarImageView)
        addSubview(nameLabel)
        addSubview(labelsView)
        
        labelsView.addSubview(labelPosts)
        labelsView.addSubview(labelNumberOfPosts)
        labelsView.addSubview(labelSubscribers)
        labelsView.addSubview(labelNumberOfSubscribers)
        labelsView.addSubview(labelSubscribes)
        labelsView.addSubview(labelNumberOfSubscribes)
        
        NSLayoutConstraint.activate([
            labelNumberOfSubscribers.topAnchor.constraint(equalTo: labelsView.topAnchor),
            labelNumberOfSubscribers.centerXAnchor.constraint(equalTo: labelsView.centerXAnchor, constant: -25),
            
            labelSubscribers.topAnchor.constraint(equalTo: labelNumberOfSubscribers.bottomAnchor, constant: 5),
            labelSubscribers.centerXAnchor.constraint(equalTo: labelsView.centerXAnchor),
            labelSubscribers.widthAnchor.constraint(equalTo: labelNumberOfSubscribers.widthAnchor, multiplier: 1),
            labelSubscribers.bottomAnchor.constraint(equalTo: labelsView.bottomAnchor),
            
            labelNumberOfPosts.topAnchor.constraint(equalTo: labelsView.topAnchor),
            labelNumberOfPosts.trailingAnchor.constraint(equalTo: labelNumberOfSubscribers.leadingAnchor, constant: -10),
            
            labelPosts.topAnchor.constraint(equalTo: labelNumberOfPosts.bottomAnchor, constant: 5),
            labelPosts.centerXAnchor.constraint(equalTo: labelNumberOfPosts.centerXAnchor),
            labelPosts.widthAnchor.constraint(equalTo: labelNumberOfPosts.widthAnchor, multiplier: 1),
            labelPosts.bottomAnchor.constraint(equalTo: labelsView.bottomAnchor),
            labelPosts.trailingAnchor.constraint(equalTo: labelSubscribers.leadingAnchor, constant: -15),
            
            labelNumberOfSubscribes.topAnchor.constraint(equalTo: labelsView.topAnchor),
            labelNumberOfSubscribes.leadingAnchor.constraint(equalTo: labelNumberOfSubscribers.trailingAnchor, constant: 10),
            
            labelSubscribes.topAnchor.constraint(equalTo: labelNumberOfSubscribes.bottomAnchor, constant: 5),
            labelSubscribes.centerXAnchor.constraint(equalTo: labelNumberOfSubscribes.centerXAnchor),
            labelSubscribes.bottomAnchor.constraint(equalTo: labelsView.bottomAnchor),
            labelSubscribes.leadingAnchor.constraint(equalTo: labelSubscribers.trailingAnchor, constant: 15),
            
            avatarImageView.topAnchor.constraint(equalTo: topAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 5),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            nameLabel.centerXAnchor.constraint(equalTo: avatarImageView.centerXAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 15),
            
            labelsView.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            labelsView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor),
            labelsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor, multiplier: 1),
        ])
        
    }
    
    private func labelsParameters(){
        if let id = Auth.auth().currentUser?.uid {
            Firestore.firestore().document("\(id)/accountInformation").getDocument { [weak self] snapshot, error in
                if error == nil {
                    if let snapshot = snapshot?.data() {
                        self?.nameLabel.text = snapshot["name"] as? String
                    }
                }
            }
        }
        
        nameLabel.textAlignment = .center
        
        
        
        labelPosts.text = "Posts"
        labelPosts.textAlignment = .center
        
        let string = "0"
        labelNumberOfPosts.attributedText = mutableAttributedString(string: string)
        labelNumberOfPosts.textAlignment = .center
        
        
        
        labelSubscribers.text = "Subscribers"
        labelSubscribers.textAlignment = .center
        let stringSubscribers = "0"
        labelNumberOfSubscribers.attributedText = mutableAttributedString(string: stringSubscribers)
        labelNumberOfSubscribers.textAlignment = .center
        
        labelSubscribes.text = "Subscribes"
        labelSubscribes.textAlignment = .center
        let stringSubscribes = "0"
        labelNumberOfSubscribes.attributedText = mutableAttributedString(string: stringSubscribes)
        labelNumberOfSubscribes.textAlignment = .center
    }
    
    private func imageViewParameters(){
        avatarImageView.image = UIImage(resource: .avatar1)
    }
    func mutableAttributedString(string: String) -> NSMutableAttributedString {
        let mutableString = NSMutableAttributedString(string: string)
        let range = (string as NSString).range(of: string)
        mutableString.addAttribute(.font, value: UIFont.systemFont(ofSize: 17, weight: .bold), range: range)
        return mutableString
    }
}


