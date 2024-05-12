//
//  TabBarController.swift
//  MusicMaxx
//
//  Created by Smart Castle M1A2009 on 14.04.2024.
//

import UIKit
import SnapKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [
        createController(viewController: SearchController(collectionViewLayout: UICollectionViewFlowLayout()), title: "Поиск", imageName: "free-icon-font-search-3917026 (1)"),
        createController(viewController: MediaController(collectionViewLayout: UICollectionViewFlowLayout()), title: "Медиатека", imageName: "free-icon-font-heart-3916576 (1)"),
//        createController(viewController: PlayerController(), title: "Плеер", imageName: "free-icon-font-music-alt-3914291 (1)"),
        ]
    }

    func createController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        let navController = UINavigationController(rootViewController: viewController)
//        navController.navigationBar.prefersLargeTitles = true
        viewController.navigationItem.title = title
//        viewController.view.backgroundColor = .white
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        
        return navController
    }
}


