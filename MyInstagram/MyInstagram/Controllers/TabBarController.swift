//
//  TabBarController.swift
//  HomeworkSaveData
//
//  Created by Иван Знак on 28/01/2024.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupTabs(){
        self.setViewControllers([], animated: false)
        self.tabBar.tintColor = .black
        let homeVC = ViewController()
        let searchVC: UIViewController = {
            let vc = UIViewController()
            vc.view.backgroundColor = .systemBackground
            return vc
        }()
        
        let addPostVC = AddPostViewController()
        
        let reelsVC: UIViewController = {
            let vc = UIViewController()
            vc.view.backgroundColor = .systemBackground
            return vc
        }()
        
        let accountVC = AccountViewController()
        
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
        nav.setNavigationBarHidden(true, animated: false)
        return nav
    }
    
}

extension TabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if tabBarController.viewControllers?[1] === viewController {
            let searchVC = UIAlertController(title: "Soon", message: "Will be soon", preferredStyle: .alert)
            showAlert(alertController: searchVC, tabBarController: tabBarController)
            return false
        } else if tabBarController.viewControllers?[3] == viewController {
            let reelsVC = UIAlertController(title: "Soon", message: "Will be soon", preferredStyle: .alert)
            showAlert(alertController: reelsVC, tabBarController: tabBarController)
            return false
        } else if tabBarController.viewControllers?[2] == viewController {
            navigationController?.pushViewController(AddPostViewController(), animated: false)
            return false
        }
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    
        if tabBarController.selectedIndex == 4 {
            let homeVC = (tabBarController.viewControllers?.first as? UINavigationController)?.viewControllers.first as? ViewController
            let accountVC = (viewController as? UINavigationController)?.viewControllers.first as? AccountViewController
            let postItems = homeVC?.postItems
            var accountItems: [CellItem] = []
            for post in postItems ?? [] {
                accountItems.append(CellItem(account: AccountItem(id: UUID().uuidString, image: post.post?.image ?? UIImage())))
            }
            accountVC?.accountItems = accountItems
            accountVC?.postItems = postItems ?? []
        }
    }
    
    func showAlert(alertController: UIAlertController, tabBarController: UITabBarController){
        let alert = alertController
        let action = UIAlertAction(title: "Ok", style: .default) { _ in
           
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
}
