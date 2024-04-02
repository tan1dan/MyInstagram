//
//  ViewController.swift
//  MyInstagram
//
//  Created by Иван Знак on 17/12/2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


protocol SendItemsDelegate: AnyObject {
    func sendItems(items: [CellItem])
}

enum Section: Hashable, CaseIterable {
    case first
    case second
}

class ViewController: UIViewController, UICollectionViewDelegate, PostBottomBarViewDelegate, /*ToolBarViewDelegate,*/ MainBarViewDelegate{
   
    let navBarView = MainNavBarView()
//    let toolBar = ToolBarView()
    lazy var mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: getCompositionalLayout())
    
    var collectionDataSource: UICollectionViewDiffableDataSource<Section, CellItem>!
    var titleItems: [CellItem] = []
    var postItems: [CellItem] = []
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Int.random(in: 100...101))
        view.backgroundColor = .systemBackground
        refreshControl.addTarget(self, action: #selector(refreshTarget), for: .valueChanged)
        constraints()
        navControllerParameters()
        storyCollectionViewParameters()
        delegateParameters()
        downloadAvatar()
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceived), name: NotificationStorage.name, object: nil)
        
        let storyCellRegistration = UICollectionView.CellRegistration<StoryCollectionViewCell, CellItem> {
            cell, indexPath, itemIdentifier in
            cell.nicknameLabel.text = itemIdentifier.story?.title
        }
        
        let postCellRegistration = UICollectionView.CellRegistration<PostCollectionViewCell, CellItem> {
            cell, IndexPath, itemIdentifier in
            cell.imageView.image = itemIdentifier.post?.image
            cell.postCommentsView.likeLabel.attributedText = itemIdentifier.post?.likeText
            cell.postCommentsView.bodyLabel.attributedText = itemIdentifier.post?.bodyText
            cell.postHeadBarView.authorLabel.text = itemIdentifier.post?.title
            cell.postHeadBarView.authorAvatar.image = itemIdentifier.post?.avatar

            cell.postBottomBarView.tag = IndexPath.row
            cell.postId = itemIdentifier.post?.postId ?? "Default value"
            cell.postBottomBarView.delegate = self
            cell.postBottomBarView.cellIndex = IndexPath.row
            
            if itemIdentifier.post?.isLiked == true {
                cell.postBottomBarView.buttonLike.setImage(UIImage(systemName: "heart.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal), for: .normal)
            } else {
                cell.postBottomBarView.buttonLike.setImage(UIImage(systemName: "heart"), for: .normal)
                cell.postBottomBarView.buttonLike.tintColor = .black
            }
            
            if itemIdentifier.post?.isBookmark == true {
                cell.postBottomBarView.buttonBookmarks.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            } else {
                cell.postBottomBarView.buttonBookmarks.setImage(UIImage(systemName: "bookmark"), for: .normal)
            }
        }
        
        collectionDataSource = UICollectionViewDiffableDataSource(collectionView: mainCollectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: CellItem) -> UICollectionViewCell? in
            if indexPath.section == 0 {
                let cell = collectionView.dequeueConfiguredReusableCell(using: storyCellRegistration, for: indexPath, item: itemIdentifier)
                return cell
            } else {
                let cell = collectionView.dequeueConfiguredReusableCell(using: postCellRegistration, for: indexPath, item: itemIdentifier)
                return cell
            }
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, CellItem>()
        snapshot.appendSections([.first, .second])
        snapshot.appendItems(titleItems, toSection: .first)
        
        snapshot.appendItems(postItems, toSection: .second)
        collectionDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        downlaodImage()
    }
    
    
    func constraints(){
        view.addSubview(navBarView)
        view.addSubview(mainCollectionView)
//        view.addSubview(toolBar)
        navBarView.translatesAutoresizingMaskIntoConstraints = false
        mainCollectionView.translatesAutoresizingMaskIntoConstraints = false
//        toolBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            navBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            navBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            navBarView.heightAnchor.constraint(equalToConstant: 40),
            
            mainCollectionView.topAnchor.constraint(equalTo: navBarView.bottomAnchor),
            mainCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
//            toolBar.topAnchor.constraint(equalTo: mainCollectionView.bottomAnchor),
//            toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            toolBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            toolBar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func delegateParameters(){
//        toolBar.delegate = self
        mainCollectionView.delegate = self
        navBarView.delegate = self
    }
    
    func getCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (section, environment) ->
            NSCollectionLayoutSection? in
            if section == 0 {
                let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(1), heightDimension: .absolute(110))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let layoutSection = NSCollectionLayoutSection(group: group)
                layoutSection.interGroupSpacing = 5
                layoutSection.orthogonalScrollingBehavior = .continuous
                return layoutSection
            } else {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                let layoutSection = NSCollectionLayoutSection(group: group)
                layoutSection.interGroupSpacing = 5
                return layoutSection
            }
        }
    }
    
    func storyCollectionViewParameters(){
        mainCollectionView.register(StoryCollectionViewCell.self, forCellWithReuseIdentifier: StoryCollectionViewCell.id)
        mainCollectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.id)
        mainCollectionView.showsVerticalScrollIndicator = false
        mainCollectionView.refreshControl = refreshControl
    }
    
    func navControllerParameters(){
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    func buttonLikePres(_ sender: PostBottomBarView) {
        let snapshot = collectionDataSource.snapshot()
        let indexPathRow = sender.tag
        let indexPath = IndexPath(row: indexPathRow, section: 1)
        
        guard let item = collectionDataSource.itemIdentifier(for: indexPath) else { return }
        guard let index = snapshot.indexOfItem(item) else {return}
        
        if self.postItems[index].post?.isLiked == false {
            UIView.animate(withDuration: 0.2, animations: {
                sender.buttonLike.setImage(UIImage(systemName: "heart.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal), for: .normal)
                let scaleTransform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                sender.buttonLike.transform = scaleTransform
                self.postItems[index].post?.isLiked?.toggle()
                self.postItems[index].post?.countLikes! += 1
                let isLiked = self.postItems[index].post?.isLiked
                let countLikes = self.postItems[index].post?.countLikes
                
                let likeText = NSMutableAttributedString(string: "Likes: \(countLikes!)")
                let range = (likeText.string as NSString).range(of: "Likes:")
                likeText.addAttribute(.font, value: UIFont.systemFont(ofSize: 17, weight: .semibold), range: range)
                self.postItems[index].post?.likeText = likeText
                
                if let id = Auth.auth().currentUser?.uid {
                    let database = Firestore.firestore().collection(id).document("postItems").collection("postItem").document(self.postItems[index].post?.postId ?? "Default Value")
                    database.updateData(["isLiked": isLiked, "Likes": countLikes])
                }
            }){ _ in
                UIView.animate(withDuration: 0.2) {
                    sender.buttonLike.transform = CGAffineTransform.identity
                }
                var snapshot = self.collectionDataSource.snapshot()
                snapshot.deleteAllItems()
                snapshot.appendSections([.first, .second])
                snapshot.appendItems(self.titleItems, toSection: .first)
                snapshot.appendItems(self.postItems, toSection: .second)
                self.collectionDataSource.apply(snapshot, animatingDifferences: false)
                self.mainCollectionView.reloadData()
                
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                sender.buttonLike.setImage(UIImage(systemName: "heart"), for: .normal)
                sender.buttonLike.tintColor = .black
                self.postItems[index].post?.isLiked?.toggle()
                self.postItems[index].post?.countLikes! -= 1
                let isLiked = self.postItems[index].post?.isLiked
                let countLikes = self.postItems[index].post?.countLikes
                let likeText = NSMutableAttributedString(string: "Likes: \(countLikes!)")
                let range = (likeText.string as NSString).range(of: "Likes:")
                likeText.addAttribute(.font, value: UIFont.systemFont(ofSize: 17, weight: .semibold), range: range)
                self.postItems[index].post?.likeText = likeText
                if let id = Auth.auth().currentUser?.uid {
                    let database = Firestore.firestore().collection(id).document("postItems").collection("postItem").document(self.postItems[index].post?.postId ?? "Default Value")
                    database.updateData(["isLiked": isLiked, "Likes": countLikes])
                }
                
                
                var snapshot = self.collectionDataSource.snapshot()
                snapshot.deleteAllItems()
                snapshot.appendSections([.first, .second])
                snapshot.appendItems(self.titleItems, toSection: .first)
                snapshot.appendItems(self.postItems, toSection: .second)
                self.collectionDataSource.apply(snapshot, animatingDifferences: false)
                self.mainCollectionView.reloadData()
            }
            
        }
        
    }
    
    func downlaodImage(avatar: UIImage){
        if let id = Auth.auth().currentUser?.uid {
            Firestore.firestore().collection(id).document("postItems").collection("postItem").getDocuments { snapshot, error in
                if error == nil {
                    if let snapshot = snapshot?.documents {
                        self.titleItems = []
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
                                        self.fillItems(id: id!, bodyString: bodyString ?? "Error", name: name ?? "Error", image: image ?? UIImage(resource: .post), avatar: avatar, isLiked: isLiked, isBookmark: isBookmark, countLikes: countLikes, postId: postId)
                                    }
                                case .failure(let error):
                                    print(error.localizedDescription)
                                }
                            }
                        }
                    }
                }
            }
            // Firestore.firestore() storyItems
        }
    }
    
    func fillItems(id: Int, bodyString: String, name: String, image: UIImage, avatar: UIImage, isLiked: Bool, isBookmark: Bool, countLikes: Int, postId: String){
        let likeText = NSMutableAttributedString(string: "Likes: \(countLikes)")
        let bodyText = NSMutableAttributedString(string: bodyString)
        let range = (likeText.string as NSString).range(of: "Likes:")
        likeText.addAttribute(.font, value: UIFont.systemFont(ofSize: 17, weight: .semibold), range: range)
        let rangeBody = (bodyText.string as NSString).range(of: name)
        bodyText.addAttribute(.font, value: UIFont.systemFont(ofSize: 17, weight: .semibold), range: rangeBody)
        
//        self.titleItems.append(CellItem(story: StoryItem(image: UIImage(resource: .avatar1) ,title: name)))
        self.postItems.append(CellItem(post: PostItem(postId: postId, image: image, avatar: avatar, title: name, likeText: likeText, bodyText: bodyText, isLiked: isLiked, isBookmark: isBookmark, countLikes: countLikes)))
        
        var snapshot = collectionDataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.first, .second])
        snapshot.appendItems(self.titleItems, toSection: .first)
        snapshot.appendItems(self.postItems, toSection: .second)
        self.collectionDataSource.apply(snapshot, animatingDifferences: true)
        self.mainCollectionView.reloadData()
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
    
    
    func buttonBookmark(_ sender: PostBottomBarView) {
        var snapshot = collectionDataSource.snapshot()
        let indexPathRow = sender.tag
        let indexPath = IndexPath(row: indexPathRow, section: 1)
        
        guard var item = collectionDataSource.itemIdentifier(for: indexPath) else { return }
        guard let index = snapshot.indexOfItem(item) else {return}
        
        if self.postItems[index].post?.isBookmark == false {
            UIView.animate(withDuration: 0.2, animations: {
                sender.buttonBookmarks.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                let scaleTransform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                sender.buttonBookmarks.transform = scaleTransform
            }){ _ in
                UIView.animate(withDuration: 0.2) {
                    sender.buttonBookmarks.transform = CGAffineTransform.identity
                }
                self.postItems[index].post?.isBookmark?.toggle()
                let isBookmark = self.postItems[index].post?.isBookmark
                if let id = Auth.auth().currentUser?.uid {
                    let database = Firestore.firestore().collection(id).document("postItems").collection("postItem").document(self.postItems[index].post?.postId ?? "Default Value")
                    database.updateData(["isBookmark": isBookmark])
                }
                var snapshot = self.collectionDataSource.snapshot()
                snapshot.deleteAllItems()
                snapshot.appendSections([.first, .second])
                snapshot.appendItems(self.titleItems, toSection: .first)
                snapshot.appendItems(self.postItems, toSection: .second)
                self.collectionDataSource.apply(snapshot, animatingDifferences: true)
                self.mainCollectionView.reloadData()
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                sender.buttonBookmarks.setImage(UIImage(systemName: "bookmark"), for: .normal)
                self.postItems[index].post?.isBookmark?.toggle()
                let isBookmark = self.postItems[index].post?.isBookmark
                if let id = Auth.auth().currentUser?.uid {
                    let database = Firestore.firestore().collection(id).document("postItems").collection("postItem").document(self.postItems[index].post?.postId ?? "Default Value")
                    database.updateData(["isBookmark": isBookmark])
                }
            }
            
            var snapshot = collectionDataSource.snapshot()
            snapshot.deleteAllItems()
            snapshot.appendSections([.first, .second])
            snapshot.appendItems(self.titleItems, toSection: .first)
            snapshot.appendItems(self.postItems, toSection: .second)
            self.collectionDataSource.apply(snapshot, animatingDifferences: true)
            self.mainCollectionView.reloadData()
        }
    }
    
    func buttonAddPostPressed(_ sender: MainNavBarView) {
        let addPostViewController = AddPostViewController()
        navigationController?.pushViewController(addPostViewController, animated: true)
    }
    
    func buttonComment(_ sender: PostBottomBarView) {
        let vc = CommentsViewController()
        vc.postId = postItems[sender.cellIndex ?? 0].post?.postId
        tabBarController?.navigationController?.present(vc, animated: true)
    }
    
    func buttonLikePressed(_ sender: MainNavBarView) {
        
    }
    
    func buttonMessagePressed(_ sender: MainNavBarView) {
        
    }
    
    
    @objc func notificationReceived(_ notification: NSNotification){
        let post = notification.userInfo?["NewPost"] as? PostItem
        postItems.append(CellItem(post: post))
        var snapshot = collectionDataSource.snapshot()
        snapshot.appendItems([CellItem(post: post)], toSection: .second)
        collectionDataSource.apply(snapshot, animatingDifferences: false)
        print(postItems)
    }
    
    @objc func refreshTarget() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            defer { self.mainCollectionView.reloadData() }
            self.downloadAvatar()
            self.refreshControl.endRefreshing()
        }
    }
    
}

