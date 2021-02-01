//
//  NewsTabBarVC.swift
//  NewsApp
//
//  Created by Satsishur on 18.01.2021.
//

import UIKit

class NewsTabBarVC: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let firstVC = HomeVC()
        let secondVC = ArchiveVC()
        let thirdVC = SettingsVC()
        firstVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName:"newspaper"), tag: 0)
        secondVC.tabBarItem = UITabBarItem(title: "Archive", image: UIImage(systemName: "bookmark.circle"), tag: 1)
        thirdVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "slider.horizontal.3"), tag: 2)
        let tabBarControllers = [firstVC, secondVC, thirdVC]

        viewControllers = tabBarControllers.map { UINavigationController(rootViewController: $0)}
        view.backgroundColor = .white
    }
}
