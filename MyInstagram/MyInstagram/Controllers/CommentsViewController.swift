//
//  CommentsViewController.swift
//  MyInstagram
//
//  Created by Иван Знак on 21/03/2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class CommentsViewController: UIViewController {
    
    let tableView = UITableView()
    let titleLabel = UILabel()
    let bottomView = CommentBottomView()
    var commentItems: [CellItem] = []
    var postId: String?
    var avatar: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadAvatar()
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        bottomView.buttonSend.addTarget(self, action: #selector(buttonSendTarget), for: .touchUpInside)
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.id)
        bottomView.avatarImageView.image = UIImage(resource: .avatar1)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        view.addSubview(bottomView)
        view.addSubview(titleLabel)
        
        tableView.separatorStyle = .none
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 50),
        ])
        let string = "Comments"
        let text = NSMutableAttributedString(string: string)
        let range = (text.string as NSString).range(of: string)
        text.addAttribute(.font, value: UIFont.systemFont(ofSize: 18, weight: .semibold), range: range)
        
        titleLabel.attributedText = text
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bottomView.avatarImageView.layer.cornerRadius = bottomView.avatarImageView.frame.size.height / 2
        bottomView.avatarImageView.layer.masksToBounds = true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func downlaodImage(avatar: UIImage){
        if let id = Auth.auth().currentUser?.uid {
            Firestore.firestore().collection(id).document("postItems").collection("postItem").document(self.postId ?? "").collection("commentItems").getDocuments { snapshot, error in
                if error == nil {
                    if let snapshot = snapshot?.documents {
                        self.commentItems = []
                        for snap in snapshot {
                            let snapData = snap.data()
                            let bodyString = snapData["body"] as! String
                            let name = snapData["title"] as! String
                            let commentId = snapData["commentId"] as! String
                            let avatar = avatar
                            self.fillItems(commentId: commentId, 
                                           bodyString: bodyString,
                                           name: name,
                                           avatar: avatar)
                        }
                    }
                }
            }
        }
    }
    
    func fillItems(commentId: String, bodyString: String, name: String, avatar: UIImage){
        let title = NSMutableAttributedString(string: name)
        let rangeTitle = (title.string as NSString).range(of: name)
        title.addAttribute(.font, value: UIFont.systemFont(ofSize: 17, weight: .semibold), range: rangeTitle)
        
        let bodyText = NSMutableAttributedString(string: bodyString)
        let rangeBody = (bodyText.string as NSString).range(of: bodyString)
        bodyText.addAttribute(.font, value: UIFont.systemFont(ofSize: 17, weight: .regular), range: rangeBody)
        
        self.commentItems.append(CellItem(comment: CommentItem(commentId: commentId, title: title, bodyTitle: bodyText, image: avatar)))
        
        self.tableView.reloadData()
    }
    
    func downloadAvatar(){
        if let id = Auth.auth().currentUser?.uid {
            
            Firestore.firestore().collection("\(id)").document("accountInformation").getDocument { snapshot, error in
                if error == nil {
                    if let snapData = snapshot?.data() {
                        let avatarID = snapData["avatar"] as! String
                        StorageManager.shared.download(id: avatarID) { result in
                            switch result {
                            case .success(let data):
                                if let avatar = UIImage(data: data) {
                                    self.downlaodImage(avatar: avatar)
                                    self.avatar = avatar
                                    self.bottomView.avatarImageView.image = avatar
                                }
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        }
                    }
                } else {
                    print(error?.localizedDescription)
                }
            }
        }
    }
    
    @objc func buttonSendTarget(){
        if bottomView.commentField.text != "" {
            setData()
        } else {
            showAlert("Error", description: "Please write a text", completion: nil)
        }
    }
    
    
    private func showAlert(_ title: String, description: String, completion: ((Bool) -> Void)?) {
        let controller = UIAlertController(title: title, message: description, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            completion?(true)
        }))
        self.present(controller, animated: true)
    }
    
    private func setData(){
        var name: String?
        var text = bottomView.commentField.text
        if let id = Auth.auth().currentUser?.uid {
            Firestore.firestore().document("\(id)/accountInformation").getDocument { snapshot, error in
                if error == nil {
                    if let snapshot = snapshot?.data() {
                        name = snapshot["name"] as? String
                        guard let name = name else {return}
                        guard let text = text else {return}
                        let commentId = UUID().uuidString
                        self.fillItems(commentId: commentId, bodyString: text, name: name, avatar: self.avatar ?? UIImage())
                        self.bottomView.commentField.text = ""
                    }
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: DispatchWorkItem(block: {
            if let id = Auth.auth().currentUser?.uid {
                guard let name = name else {return}
                guard let text = text else {return}
                let commentId = UUID().uuidString
                let database = Firestore.firestore().collection(id).document("postItems").collection("postItem").document(self.postId ?? "").collection("commentItems").document(commentId)
                database.setData(["commentId": commentId, "title": name, "body": text ])
               
            }
        }))
        
    }
}

extension CommentsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.id, for: indexPath) as! CommentTableViewCell
        let item = commentItems[indexPath.row]
        cell.avatarView.image = item.comment?.image
        cell.titleLabel.attributedText = item.comment?.title
        cell.bodyLabel.attributedText = item.comment?.bodyTitle
        cell.selectionStyle = .none
        return cell
    }
    
}
