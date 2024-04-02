//
//  AccountViewController.swift
//  MyInstagram
//
//  Created by Иван Знак on 11/01/2024.
//

import UIKit
import Firebase

class AccountViewController: UIViewController, AccountNavBarViewDelegate, /*ToolBarViewDelegate,*/ SendItemsDelegate { // TODO: remove comments
    
    let navBarView = AccountNavBarView()
//    let toolBar = ToolBarView() // TODO: remove comments
    let accountView = MainAccountViewUpdate()
    let refreshControl = UIRefreshControl()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: getCompositionalLayout())
    var accountItems: [CellItem] = []
    var postItems: [CellItem] = []
    var collectionDataSource: UICollectionViewDiffableDataSource<Section, CellItem>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.addTarget(self, action: #selector(refreshTarget), for: .valueChanged)
        constraints()
        downloadAvatar()
        collectionViewParameters()
        view.backgroundColor = .systemBackground
//        toolBar.delegate = self // TODO: remove comments
        navBarView.delegate = self
        
        let cellRegistration = UICollectionView.CellRegistration<AccountCollectionViewCell, CellItem> {
            cell, indexPath, itemIdentifier in
            cell.imageView.image = itemIdentifier.account?.image
        }
        
        collectionDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: CellItem) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell // TODO return cell in previous line
        }
        
        var accountSnapshot = NSDiffableDataSourceSnapshot<Section, CellItem>()
        accountSnapshot.appendSections([.first])
        accountSnapshot.appendItems(accountItems, toSection: .first)
        collectionDataSource.apply(accountSnapshot, animatingDifferences: true)
    }
    
    private func constraints(){
        view.addSubview(navBarView)
//        view.addSubview(toolBar) // TODO: remove comments
        view.addSubview(accountView)
        view.addSubview(collectionView)
        navBarView.translatesAutoresizingMaskIntoConstraints = false
//        toolBar.translatesAutoresizingMaskIntoConstraints = false // TODO: remove comments
        accountView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            navBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            navBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            navBarView.heightAnchor.constraint(equalToConstant: 40),
            
            accountView.topAnchor.constraint(equalTo: navBarView.bottomAnchor),
            accountView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            accountView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            accountView.heightAnchor.constraint(equalToConstant: 120),
            
            collectionView.topAnchor.constraint(equalTo: accountView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // TODO: remove comments
//            toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            toolBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            toolBar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        accountView.avatarImageView.image = postItems.first?.post?.avatar
        var accountSnapshot = collectionDataSource.snapshot()
        accountSnapshot.deleteAllItems()
        accountSnapshot.appendSections([.first])
        accountSnapshot.appendItems(accountItems, toSection: .first)
        collectionDataSource.apply(accountSnapshot, animatingDifferences: true)
        collectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        accountView.avatarImageView.layer.cornerRadius = accountView.avatarImageView.frame.size.width / 2
        accountView.avatarImageView.clipsToBounds = true
    }
    
    func getCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (section, environment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let group1size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(self.view.frame.size.width / 3))
            
            let group1 = NSCollectionLayoutGroup.horizontal(layoutSize: group1size, subitems: [group])
            group1.interItemSpacing = .fixed(3)
            let layoutSection = NSCollectionLayoutSection(group: group1)
            layoutSection.interGroupSpacing = 3
            return layoutSection
        }
    }
    
    private func collectionViewParameters() {
        collectionView.register(AccountCollectionViewCell.self, forCellWithReuseIdentifier: AccountCollectionViewCell.id)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.refreshControl = refreshControl
    }
    
    // TODO: is this method used?
    func buttonAddPostPress(_ sender: ToolBarView) {
        let addPostViewController = AddPostViewController()
        navigationController?.pushViewController(addPostViewController, animated: true)
    }
    
    func sendItems(items: [CellItem]) {
        accountItems = items
        print(accountItems)
    }
    
    func buttonAddPostPressed(_ sender: AccountNavBarView) {
        let addPostVC = AddPostViewController()
        navigationController?.pushViewController(addPostVC, animated: true)
    }
    
    func buttonParameterPressed(_ sender: AccountNavBarView) {
        
    }
    
    func buttonLogOutPressed(_ sender: AccountNavBarView) {
        do{
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
//        #error("check nav")
        tabBarController?.navigationController?.popToRootViewController(animated: true)
//            .setViewControllers([AuthViewController()], animated: false)
    }
    
    @objc func refreshTarget() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            defer { self.collectionView.reloadData() }
            self.downloadAvatar()
            self.refreshControl.endRefreshing()
        }
    }
    
}

extension AccountViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = AccountPostsViewController()
        vc.postItems = postItems
        vc.indexPath = indexPath
        tabBarController?.navigationController?.pushViewController(vc, animated: false)
        tabBarController?.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func downlaodImage(avatar: UIImage){
        if let id = Auth.auth().currentUser?.uid {
            Firestore.firestore().collection(id).document("postItems").collection("postItem").getDocuments { snapshot, error in // TODO: memory leak
                if error == nil {
                    if let snapshot = snapshot?.documents {
                        self.accountItems = []
                        self.postItems = []
                        for snap in snapshot {
                            let snapData = snap.data()
                            let id = snapshot.firstIndex(of: snap)
                            let bodyString = snapData["bodyText"] as? String
                            let name = snapData["title"] as? String
                            let imageId = snapData["imageId"] as! String
                            let isLiked = snapData["isLiked"] as! Bool
                            let isBookmark = snapData["isBookmark"] as! Bool
                            let countLikes = snapData["Likes"] as! Int
                            let postId = snapData["postId"] as! String
                            var image: UIImage?
                            let avatar = avatar
                            StorageManager.shared.download(id: imageId) { result in
                                switch result {
                                case .success(let data):
                                    if let imageOne = UIImage(data: data) {
                                        image = imageOne
                                        self.fillItems(id: id!, 
                                                       bodyString: bodyString ?? "Error",
                                                       name: name ?? "Error",
                                                       image: image ?? UIImage(resource: .post),
                                                       avatar: avatar,
                                                       isLiked: isLiked,
                                                       isBookmark: isBookmark,
                                                       countLikes: countLikes,
                                                       postId: postId)
                                    }
                                case .failure(let error):
                                    print(error.localizedDescription)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func fillItems(id: Int, bodyString: String, name: String, image: UIImage, avatar: UIImage, isLiked: Bool, isBookmark: Bool, countLikes: Int, postId: String){
        let likeText = NSMutableAttributedString(string: "Likes: \(countLikes)")
        let bodyText = NSMutableAttributedString(string: bodyString)
        let range = (likeText.string as NSString).range(of: "Likes:")
        likeText.addAttribute(.font, value: UIFont.systemFont(ofSize: 17, weight: .semibold), range: range)
        let rangeBody = (bodyText.string as NSString).range(of: name)
        bodyText.addAttribute(.font, value: UIFont.systemFont(ofSize: 17, weight: .semibold), range: rangeBody)
        
//        self.titleItems.append(CellItem(story: StoryItem(image: UIImage(resource: .avatar1) ,title: name)))     // TODO: is this method used?
        self.postItems.append(CellItem(post: PostItem(postId: postId, image: image, avatar: avatar, title: name, likeText: likeText, bodyText: bodyText, isLiked: isLiked, isBookmark: isBookmark, countLikes: countLikes)))
        self.accountItems.append(CellItem(account: AccountItem(id: UUID().uuidString, image: image)))
        var snapshot = collectionDataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.first])
        snapshot.appendItems(self.accountItems, toSection: .first)
        self.collectionDataSource.apply(snapshot, animatingDifferences: true)
        self.collectionView.reloadData()
    }
    
    func downloadAvatar(){
        if let id = Auth.auth().currentUser?.uid {
            
            Firestore.firestore().collection("\(id)").document("accountInformation").getDocument { snapshot, error in // TODO: memory leak
                if error == nil {
                    if let snapData = snapshot?.data() {
                        let avatarID = snapData["avatar"] as! String
                        StorageManager.shared.download(id: avatarID) { result in
                            switch result {
                            case .success(let data):
                                if let avatar = UIImage(data: data) {
                                    self.downlaodImage(avatar: avatar)
                                    self.accountView.avatarImageView.image = avatar
                                }
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        }
                    }
                } else {
                    print(error?.localizedDescription) // TODO: Remove print, add alert, toast, image or text to show user message
                }
            }
        }
    }
}

