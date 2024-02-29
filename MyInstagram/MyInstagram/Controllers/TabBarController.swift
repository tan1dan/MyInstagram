//
//  TabBarController.swift
//  HomeworkSaveData
//
//  Created by Иван Знак on 28/01/2024.
//

import UIKit

class TabBarController: UITabBarController, SendItemsDelegate {
    var accountItems: [CellItem]?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    private func setupTabs(){
        self.setViewControllers([], animated: false)
        let homeVC = ViewController()
        homeVC.delegate = self
        let searchVC: UIViewController = {
            let vc = UIViewController()
            vc.view.backgroundColor = .systemBackground
            return vc
        }()
        
        let addPostVC: UIViewController = {
            let vc = UIViewController()
            vc.view.backgroundColor = .systemBackground
            return vc
        }()
        
        let reelsVC: UIViewController = {
            let vc = UIViewController()
            vc.view.backgroundColor = .systemBackground
            return vc
        }()
        
        let accountVC = AccountViewController()
        accountVC.accountItems = accountItems ?? [CellItem]()
        
        let home = createNav(image: UIImage(systemName: "house"), vc: homeVC)
        let search = createNav(image: UIImage(systemName: "magnifyingglass"), title: "Soon", vc: searchVC)
        let addPost = createNav(image: UIImage(systemName: "plus.viewfinder"), vc: addPostVC)
        let reels = createNav(image: UIImage(systemName: "play.square"), title: "Soon", vc: reelsVC)
        let account = createNav(image: UIImage(systemName: "person.crop.circle"), vc: accountVC)
        
        self.setViewControllers([home, search, addPost, reels, account], animated: true)
    }
    
    private func createNav(image: UIImage?, title: String? = nil, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        if let title = title {
            nav.tabBarItem.title = title
        }
        nav.tabBarItem.image = image
        return nav
    }
    
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 2 {
            navigationController?.pushViewController(AddPostViewController(), animated: false)
        } else if tabBarController.selectedIndex == 1 {
            let searchVC = UIAlertController(title: "Soon", message: "Will be soon", preferredStyle: .alert)
            showAlert(alertController: searchVC, tabBarController: tabBarController)
        } else if tabBarController.selectedIndex == 3 {
            let reelsVC = UIAlertController(title: "Soon", message: "Will be soon", preferredStyle: .alert)
            showAlert(alertController: reelsVC, tabBarController: tabBarController)
        } else if tabBarController.selectedIndex == 4 {
            
        }
    }
    
    func showAlert(alertController: UIAlertController, tabBarController: UITabBarController){
        let alert = alertController
        let action = UIAlertAction(title: "Ok", style: .default) { _ in
            tabBarController.selectedIndex = 0
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func sendItems(items: [CellItem]) {
        accountItems = items
    }
    
}
