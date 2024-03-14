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
        view.backgroundColor = .systemBackground
        refreshControl.addTarget(self, action: #selector(refreshTarget), for: .valueChanged)
        constraints()
        navControllerParameters()
        storyCollectionViewParameters()
        delegateParameters()
        downlaodImage()
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
            
            cell.postBottomBarView.tag = IndexPath.row
            cell.postBottomBarView.delegate = self
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
        var snapshot = collectionDataSource.snapshot()
        let indexPathRow = sender.tag
        let indexPath = IndexPath(row: indexPathRow, section: 1)
        
        guard var item = collectionDataSource.itemIdentifier(for: indexPath) else { return }
        let index = snapshot.indexOfItem(item)
        if item.post?.isLiked == false {
            UIView.animate(withDuration: 0.2, animations: {
                sender.buttonLike.setImage(UIImage(systemName: "heart.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal), for: .normal)
                let scaleTransform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                sender.buttonLike.transform = scaleTransform
            }){ _ in
                UIView.animate(withDuration: 0.2) {
                    sender.buttonLike.transform = CGAffineTransform.identity
                }
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                sender.buttonLike.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }
        
        if var postItem = item.post {
            postItem.isLiked.toggle()
            print(postItem.isLiked)
            item.post = postItem
        }
        
        snapshot.reloadItems([snapshot.itemIdentifiers[index!]])
        collectionDataSource.apply(snapshot, animatingDifferences: true)
        
    }
    
    func downlaodImage(){
        
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
                            var image: UIImage?
                            
                            StorageManager.shared.download(id: imageId) { result in
                                switch result {
                                case .success(let data):
                                    if let imageOne = UIImage(data: data) {
                                        image = imageOne
                                        self.fillItems(id: id!, bodyString: bodyString ?? "Error", name: name ?? "Error", image: image ?? UIImage(resource: .post))
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
    
    func fillItems(id: Int, bodyString: String, name: String, image: UIImage){
        let likeText = NSMutableAttributedString(string: "Likes: \(id)")
        let bodyText = NSMutableAttributedString(string: bodyString)
        let range = (likeText.string as NSString).range(of: "Likes:")
        likeText.addAttribute(.font, value: UIFont.systemFont(ofSize: 17, weight: .semibold), range: range)
        let rangeBody = (bodyText.string as NSString).range(of: name)
        bodyText.addAttribute(.font, value: UIFont.systemFont(ofSize: 17, weight: .semibold), range: rangeBody)
        
//        self.titleItems.append(CellItem(story: StoryItem(image: UIImage(resource: .avatar1) ,title: name)))
        self.postItems.append(CellItem(post: PostItem(image: image, title: name, likeText: likeText, bodyText: bodyText, isLiked: false, isBookmark: false)))
        
        var snapshot = collectionDataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.first, .second])
        snapshot.appendItems(self.titleItems, toSection: .first)
        snapshot.appendItems(self.postItems, toSection: .second)
        self.collectionDataSource.apply(snapshot, animatingDifferences: true)
        self.mainCollectionView.reloadData()
    }
    
    func buttonBookmark(_ sender: PostBottomBarView) {
        
    }
    
    func buttonAddPostPressed(_ sender: MainNavBarView) {
        let addPostViewController = AddPostViewController()
        navigationController?.pushViewController(addPostViewController, animated: true)
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
            self.downlaodImage()
            self.refreshControl.endRefreshing()
        }
    }
}

