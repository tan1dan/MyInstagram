//
//  AccountViewController.swift
//  MyInstagram
//
//  Created by Иван Знак on 11/01/2024.
//

import UIKit
import Firebase

class AccountViewController: UIViewController, AccountNavBarViewDelegate, /*ToolBarViewDelegate,*/ SendItemsDelegate {
    
    let navBarView = AccountNavBarView()
//    let toolBar = ToolBarView()
    let accountView = MainAccountView()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: getCompositionalLayout())
    var accountItems: [CellItem] = []
    
    var collectionDataSource: UICollectionViewDiffableDataSource<Section, CellItem>!
    
    var sendItems: (() -> [CellItem])?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        constraints()
        collectionViewParameters()
        view.backgroundColor = .systemBackground
//        toolBar.delegate = self
        navBarView.delegate = self
        
        let cellRegistration = UICollectionView.CellRegistration<AccountCollectionViewCell, CellItem> {
            cell, indexPath, itemIdentifier in
            cell.imageView.image = itemIdentifier.account?.image
        }
        
        collectionDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: CellItem) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
                return cell
        }
        
        var accountSnapshot = NSDiffableDataSourceSnapshot<Section, CellItem>()
        accountSnapshot.appendSections([.first])
        accountSnapshot.appendItems(accountItems, toSection: .first)
        collectionDataSource.apply(accountSnapshot, animatingDifferences: true)
    }
    
    private func constraints(){
        view.addSubview(navBarView)
//        view.addSubview(toolBar)
        view.addSubview(accountView)
        view.addSubview(collectionView)
        navBarView.translatesAutoresizingMaskIntoConstraints = false
//        toolBar.translatesAutoresizingMaskIntoConstraints = false
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
            
//            toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            toolBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            toolBar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let items = sendItems?() {
            accountItems = items
        }
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
    
    private func collectionViewParameters(){
        collectionView.register(AccountCollectionViewCell.self, forCellWithReuseIdentifier: AccountCollectionViewCell.id)
        collectionView.showsVerticalScrollIndicator = false
        
    }
    
    
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
        navigationController?.pushViewController(AuthViewController(), animated: true)
    }
}
