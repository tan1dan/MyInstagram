//
//  AccountPostsViewController.swift
//  MyInstagram
//
//  Created by Иван Знак on 12/03/2024.
//

import UIKit

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
            
            cell.postBottomBarView.tag = IndexPath.row
            cell.postBottomBarView.delegate = self
        }
        
        collectionDataSource = UICollectionViewDiffableDataSource(collectionView: mainCollectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: CellItem) -> UICollectionViewCell? in
            let cell = collectionView.dequeueConfiguredReusableCell(using: postCellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, CellItem>()
        snapshot.appendSections([.first])
        snapshot.appendItems(postItems, toSection: .first)
        collectionDataSource.apply(snapshot, animatingDifferences: true)
        constraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.title = "Posts"
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.setLeftBarButton(UIBarButtonItem(customView: backButton), animated: false)
        backButton.addTarget(self, action: #selector(buttonBackTarget), for: .touchUpInside)
        
        if let indexPath = self.indexPath {
            mainCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .top)
           
        }
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
        
    }
    
    func buttonBookmark(_ sender: PostBottomBarView) {
        
    }
    
}

