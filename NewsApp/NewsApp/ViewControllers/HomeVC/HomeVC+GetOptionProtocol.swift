//
//  ArticleVC+CategoryProtocol.swift
//  NewsApp
//
//  Created by Satsishur on 29.01.2021.
//

import UIKit

protocol GetOptionProtocol {
    func getOption(option: String)
}

extension HomeVC: GetOptionProtocol {
    func getOption(option: String) {
        print(option)
        switch segmentedControl.selectedSegmentIndex {
        case Options.category.rawValue:
            self.category = option
        case Options.source.rawValue:
            self.source = option
        default:
            self.country = option
        }
        headerTitle = option
        setupOptionsAndFetchNews()
    }
}
