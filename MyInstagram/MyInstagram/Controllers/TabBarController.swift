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
    }
    private func setupTabs(){
        let vc = ViewController()
        let scoreVC = ScoreViewController()
        let game = createNav(with: "Game", and: UIImage(systemName: "gamecontroller"), vc: vc)
        let score = createNav(with: "Score", and: UIImage(systemName: "list.number"), vc: scoreVC)
        scoreVC.delegate = vc
        self.setViewControllers([game, score], animated: true)
    }
    
    private func createNav(with title: String, and image: UIImage? , vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        return nav
    }
}
