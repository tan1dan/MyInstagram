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
    let toolBar = ToolBarView()
    lazy var storyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: getCompositionalLayout())
    
    var collectionDataSource: UICollectionViewDiffableDataSource<Section, StoryCellItem>!
    var titleItems: [StoryCellItem] = []
    var postItems: [StoryCellItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        fillItems()
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
            cell.postCommentsView.likeLabel.attributedText = itemIdentifier.likeText
            cell.postCommentsView.bodyLabel.attributedText = itemIdentifier.bodyText
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
        view.addSubview(toolBar)
        navBarView.translatesAutoresizingMaskIntoConstraints = false
        storyCollectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            navBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            navBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            navBarView.heightAnchor.constraint(equalToConstant: 40),
            
            storyCollectionView.topAnchor.constraint(equalTo: navBarView.bottomAnchor),
            storyCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            storyCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            toolBar.topAnchor.constraint(equalTo: storyCollectionView.bottomAnchor),
            toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            toolBar.heightAnchor.constraint(equalToConstant: 50)
        ])
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
        storyCollectionView.delegate = self
        storyCollectionView.register(StoryCollectionViewCell.self, forCellWithReuseIdentifier: StoryCollectionViewCell.id)
        storyCollectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.id)
    }
    
    func navControllerParameters(){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func fillItems(){
        
        for i in 1...10{
            let likeText = NSMutableAttributedString(string: "Likes: \(i)")
            let bodyText = NSMutableAttributedString(string: "NAME lsalkjadjald test text")
            let range = (likeText.string as NSString).range(of: "Likes:")
            likeText.addAttribute(.font, value: UIFont.systemFont(ofSize: 17, weight: .semibold), range: range)
            let rangeBody = (bodyText.string as NSString).range(of: "NAME")
            bodyText.addAttribute(.font, value: UIFont.systemFont(ofSize: 17, weight: .semibold), range: rangeBody)
            titleItems.append(StoryCellItem(title: "Arisha\(i)"))
            postItems.append(StoryCellItem(image: UIImage(resource: .post), title: "Arisha\(i)", likeText: likeText, bodyText: bodyText))
        }
    }
    
}
