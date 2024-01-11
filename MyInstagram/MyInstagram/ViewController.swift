//
//  ViewController.swift
//  MyInstagram
//
//  Created by Иван Знак on 17/12/2023.
//

import UIKit

enum Section: Hashable, CaseIterable {
    case first
    case second
}

class ViewController: UIViewController, UICollectionViewDelegate, PostBottomBarViewDelegate, ToolBarViewDelegate, MainBarViewDelegate {
    
    let navBarView = MainNavBarView()
    let toolBar = ToolBarView()
    lazy var mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: getCompositionalLayout())
    
    var collectionDataSource: UICollectionViewDiffableDataSource<Section, CellItem>!
    var titleItems: [CellItem] = []
    var postItems: [CellItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        fillItems()
        constraints()
        navControllerParameters()
        storyCollectionViewParameters()
        delegateParameters()
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
    
    
    func constraints(){
        view.addSubview(navBarView)
        view.addSubview(mainCollectionView)
        view.addSubview(toolBar)
        navBarView.translatesAutoresizingMaskIntoConstraints = false
        mainCollectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            navBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            navBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            navBarView.heightAnchor.constraint(equalToConstant: 40),
            
            mainCollectionView.topAnchor.constraint(equalTo: navBarView.bottomAnchor),
            mainCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            toolBar.topAnchor.constraint(equalTo: mainCollectionView.bottomAnchor),
            toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            toolBar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func delegateParameters(){
        toolBar.delegate = self
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
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
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
    }
    
    func navControllerParameters(){
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func fillItems(){
        
        for i in 1...10{
            let likeText = NSMutableAttributedString(string: "Likes: \(i)")
            let bodyText = NSMutableAttributedString(string: "NAME lsalkjadjald test text")
            let range = (likeText.string as NSString).range(of: "Likes:")
            likeText.addAttribute(.font, value: UIFont.systemFont(ofSize: 17, weight: .semibold), range: range)
            let rangeBody = (bodyText.string as NSString).range(of: "NAME")
            bodyText.addAttribute(.font, value: UIFont.systemFont(ofSize: 17, weight: .semibold), range: rangeBody)
            titleItems.append(CellItem(story: StoryItem(title: "Arisha\(i)")))
            postItems.append(CellItem(post: PostItem(image: UIImage(resource: .post), title: "Arisha\(i)", likeText: likeText, bodyText: bodyText, isLiked: false, isBookmark: false)))
        }
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
    
    func buttonBookmark(_ sender: PostBottomBarView) {
        
    }
    
    func buttonAddPostPress(_ sender: ToolBarView) {
        let addPostViewController = AddPostViewController()
        navigationController?.pushViewController(addPostViewController, animated: true)
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
}
