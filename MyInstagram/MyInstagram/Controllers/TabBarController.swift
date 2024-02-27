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
    
    private func setupTabs(){
        let homeVC = ViewController()
        let action = UIAlertAction(title: "Ok", style: .default) { _ in
            self.navigationController?.popViewController(animated: false)
        }
        let searchVC = UIAlertController(title: "Soon", message: "Will be soon", preferredStyle: .alert)
        searchVC.addAction(action)
        let addPostVC = AddPostViewController()
        let reelsVC = UIAlertController(title: "Soon", message: "Will be soon", preferredStyle: .alert)
        reelsVC.addAction(action)
        let accountVC = AccountViewController()
        
        let home = createNav(image: UIImage(systemName: "house"), vc: homeVC)
        let search = createNav(image: UIImage(systemName: "magnifyingglass"), vc: searchVC)
        let addPost = createNav(image: UIImage(systemName: "plus.viewfinder"), vc: addPostVC)
        let reels = createNav(image: UIImage(systemName: "play.square"), vc: reelsVC)
        let account = createNav(image: UIImage(systemName: "person.crop.circle"), vc: accountVC)
        
        self.setViewControllers([home, search, addPost, reels, account], animated: true)
    }
    
    private func createNav(image: UIImage? , vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.image = image
        return nav
    }
    
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
    }
//    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        if item == tabBar.items?[2] {
//            navigationController?.pushViewController(AddPostViewController(), animated: true)
//        }
//    }
}
