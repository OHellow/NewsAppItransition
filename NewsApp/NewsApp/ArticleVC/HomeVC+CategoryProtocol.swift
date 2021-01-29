//
//  ArticleVC+CategoryProtocol.swift
//  NewsApp
//
//  Created by Satsishur on 29.01.2021.
//

import UIKit

protocol CategoryProtocol {
    func getOption(option: String)
}

extension HomeVC: CategoryProtocol {
    func getOption(option: String) {
        print(option)
        switch segmentedControl.selectedSegmentIndex {
        case 2:
            self.category = option
        case 3:
            self.source = option
        default:
            self.country = option
        }
        headerTitle = option
        setupOptionsAndFetchNews()
    }
}
