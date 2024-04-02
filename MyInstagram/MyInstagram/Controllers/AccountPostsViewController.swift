//
//  AccountPostsViewController.swift
//  MyInstagram
//
//  Created by Иван Знак on 12/03/2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class AccountPostsViewController: UIViewController, PostBottomBarViewDelegate {
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back", for: .normal)
        return button
    }()
    
    lazy var mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: getCompositionalLayout())
    
    var collectionDataSource: UICollectionViewDiffableDataSource<Section, CellItem>!
    var postItems: [CellItem] = []
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
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
            let cell = collectionView.dequeueConfiguredReusableCell(using: postCellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, CellItem>()
        snapshot.appendSections([.first])
        snapshot.appendItems(postItems, toSection: .first)
        collectionDataSource.apply(snapshot, animatingDifferences: true) {
            if let indexPath = self.indexPath {
                self.mainCollectionView.scrollToItem(at: indexPath, at: .top, animated: false)
            }
        }
        mainCollectionView.showsVerticalScrollIndicator = false
        constraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.title = "Posts"
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.setLeftBarButton(UIBarButtonItem(customView: backButton), animated: false)
        backButton.addTarget(self, action: #selector(buttonBackTarget), for: .touchUpInside)
    }
    
    func getCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (section, environment) ->
            NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            let layoutSection = NSCollectionLayoutSection(group: group)
            layoutSection.interGroupSpacing = 5
            return layoutSection
        }
    }
    
    private func constraints(){
        mainCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainCollectionView)
        NSLayoutConstraint.activate([
            mainCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    @objc func buttonBackTarget(){
        navigationController?.popViewController(animated: false)
    }
    
    func buttonLikePres(_ sender: PostBottomBarView) {
        let snapshot = collectionDataSource.snapshot()
        let indexPathRow = sender.tag
        let indexPath = IndexPath(row: indexPathRow, section: 0)
        
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
                snapshot.appendSections([.first])
                snapshot.appendItems(self.postItems, toSection: .first)
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
                snapshot.appendSections([.first])
                snapshot.appendItems(self.postItems, toSection: .first)
                self.collectionDataSource.apply(snapshot, animatingDifferences: false)
                self.mainCollectionView.reloadData()
            }
            
        }
        print(self.postItems[index].post?.isLiked)
        
    }
    
    func buttonBookmark(_ sender: PostBottomBarView) {
        let snapshot = collectionDataSource.snapshot()
        let indexPathRow = sender.tag
        let indexPath = IndexPath(row: indexPathRow, section: 0)
        
        guard let item = collectionDataSource.itemIdentifier(for: indexPath) else { return }
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
                snapshot.appendSections([.first])
                snapshot.appendItems(self.postItems, toSection: .first)
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
            snapshot.appendSections([.first])
            snapshot.appendItems(self.postItems, toSection: .first)
            self.collectionDataSource.apply(snapshot, animatingDifferences: true)
            self.mainCollectionView.reloadData()
        }
    }
    
    func buttonComment(_ sender: PostBottomBarView) {
         let vc = CommentsViewController()
        vc.postId = postItems[sender.cellIndex ?? 0].post?.postId
        navigationController?.present(vc, animated: true)
    }
    
}

