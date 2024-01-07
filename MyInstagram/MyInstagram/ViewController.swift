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

class ViewController: UIViewController, UICollectionViewDelegate {
    let navBarView = MainNavBarView()
    lazy var storyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: getCompositionalLayout())
    
    var collectionDataSource: UICollectionViewDiffableDataSource<Section, StoryCellItem>!
    var titleItems: [StoryCellItem] = []
    var postItems: [StoryCellItem] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        fillItems()
        
        registerForTraitChanges([UITraitUserInterfaceStyle.self], handler: { (self: Self, previousTraitCollection: UITraitCollection) in
            if self.traitCollection.userInterfaceStyle == .light {
                self.lightMode()
                
            } else {
                self.darkMode()
            }
        })
        
        constraints()
        navControllerParameters()
        storyCollectionViewParameters()
        
        let cellRegistration = UICollectionView.CellRegistration<StoryCollectionViewCell, StoryCellItem> {
            cell, indexPath, itemIdentifier in
            cell.nicknameLabel.text = itemIdentifier.title
        }
        
        let secondCellRegistration = UICollectionView.CellRegistration<PostCollectionViewCell, StoryCellItem> {
            cell, IndexPath, itemIdentifier in
            cell.imageView.image = itemIdentifier.image
            cell.postCommentsView.likeLabel.text = itemIdentifier.likeText
            cell.postCommentsView.bodyLabel.text = itemIdentifier.bodyText
            cell.postHeadBarView.authorLabel.text = itemIdentifier.title
        }
        
        collectionDataSource = UICollectionViewDiffableDataSource(collectionView: storyCollectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: StoryCellItem) -> UICollectionViewCell? in
            if indexPath.section == 0 {
                let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
                return cell
            } else {
                let cell = collectionView.dequeueConfiguredReusableCell(using: secondCellRegistration, for: indexPath, item: itemIdentifier)
                return cell
            }
        }
        
        var firstSnapshot = NSDiffableDataSourceSnapshot<Section, StoryCellItem>()
        firstSnapshot.appendSections([.first, .second])
        firstSnapshot.appendItems(titleItems, toSection: .first)
        firstSnapshot.appendItems(postItems, toSection: .second)
        collectionDataSource.apply(firstSnapshot, animatingDifferences: true)
    }
    
    func constraints(){
        view.addSubview(navBarView)
        view.addSubview(storyCollectionView)
        navBarView.translatesAutoresizingMaskIntoConstraints = false
        storyCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            navBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            navBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            navBarView.heightAnchor.constraint(equalToConstant: 40),
            
            storyCollectionView.topAnchor.constraint(equalTo: navBarView.bottomAnchor),
            storyCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            storyCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            storyCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func lightMode(){
        self.navBarView.buttonAddPost.tintColor = .black
        self.navBarView.buttonLike.tintColor = .black
        self.navBarView.buttonMessage.tintColor = .black
        self.navBarView.label.textColor = .black
    }
    
    func darkMode(){
        self.navBarView.buttonAddPost.tintColor = .white
        self.navBarView.buttonLike.tintColor = .white
        self.navBarView.buttonMessage.tintColor = .white
        self.navBarView.label.textColor = .white
    }
    
    func getCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (section, environment) ->
            NSCollectionLayoutSection? in
            if section == 0 {
                let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(1), heightDimension: .fractionalHeight(1/7))
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
        storyCollectionView.delegate = self
        storyCollectionView.register(StoryCollectionViewCell.self, forCellWithReuseIdentifier: StoryCollectionViewCell.id)
        storyCollectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.id)
    }
    
    func navControllerParameters(){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func fillItems(){
        for i in 1...10{
            titleItems.append(StoryCellItem(title: "avatar\(i)"))
            postItems.append(StoryCellItem(image: UIImage(resource: .post), title: "Arisha\(i)", likeText: "Likes: \(i)", bodyText: "NAME lsalkjadjald test text"))
        }
        print(postItems)
    }
}
