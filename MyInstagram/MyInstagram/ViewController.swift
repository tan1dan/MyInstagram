//
//  ViewController.swift
//  MyInstagram
//
//  Created by Иван Знак on 17/12/2023.
//

import UIKit

enum Section: Hashable, CaseIterable {
    case first
}

class ViewController: UIViewController, UICollectionViewDelegate {
    let navBarView = MainNavBarView()
    lazy var storyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: getCompositionalLayout())
    var collectionDataSource: UICollectionViewDiffableDataSource<Section, StoryCellItem>!
    var titleItems: [StoryCellItem] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        fillTitleItems()
        
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
        
        collectionDataSource = UICollectionViewDiffableDataSource(collectionView: storyCollectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: StoryCellItem) -> UICollectionViewCell? in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
                return cell
        }
        
        var firstSnapshot = NSDiffableDataSourceSnapshot<Section, StoryCellItem>()
        firstSnapshot.appendSections([.first])
        firstSnapshot.appendItems(titleItems, toSection: .first)
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
            storyCollectionView.trailingAnchor.constraint(equalTo: vцiew.trailingAnchor),
            storyCollectionView.heightAnchor.constraint(equalToConstant: 110)
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
            let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(1), heightDimension: .fractionalHeight(1))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let layoutSection = NSCollectionLayoutSection(group: group)
            layoutSection.interGroupSpacing = 5
            layoutSection.orthogonalScrollingBehavior = .continuous
            return layoutSection
        }
    }
    
    func storyCollectionViewParameters(){
        storyCollectionView.delegate = self
        storyCollectionView.register(StoryCollectionViewCell.self, forCellWithReuseIdentifier: StoryCollectionViewCell.id)
    }
    
    func navControllerParameters(){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    func fillTitleItems(){
        for i in 1...10{
            titleItems.append(StoryCellItem(title: "avatar\(i)"))
        }
    }
}
