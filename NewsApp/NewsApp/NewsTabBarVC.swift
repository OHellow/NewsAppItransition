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
        let firstVC = UINavigationController(rootViewController: ArticleVC())
        let secondVC = SourceVC()
        let thirdVC = SavedNewsVC()
        firstVC.tabBarItem = UITabBarItem(title: "Article", image: UIImage(systemName:"newspaper"), tag: 0)
        secondVC.tabBarItem = UITabBarItem(title: "Sources", image: UIImage(systemName: "server.rack"), tag: 1)
        thirdVC.tabBarItem = UITabBarItem(title: "Saved News", image: UIImage(systemName: "bookmark.circle"), tag: 2)
        let tabBarControllers = [firstVC, secondVC, thirdVC]

        viewControllers = tabBarControllers//.map { UINavigationController(rootViewController: $0)}
        view.backgroundColor = .white
    }
}
