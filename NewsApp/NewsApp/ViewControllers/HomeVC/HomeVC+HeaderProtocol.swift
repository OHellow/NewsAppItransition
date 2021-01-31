//
//  ArticleVC+HeaderProtocol.swift
//  NewsApp
//
//  Created by Satsishur on 29.01.2021.
//

import UIKit

protocol HeaderDelegate {
    func getTitles()
}

extension HomeVC: HeaderDelegate {
    func getTitles() {
        let vc = OptionsVC()
        vc.delegate = self
        switch segmentedControl.selectedSegmentIndex {
        case Options.category.rawValue:
            vc.dataSource = Constants.categories
        case Options.source.rawValue:
            vc.isSources = true
        default:
            vc.dataSource = Constants.countries
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
