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
        case 2:
            vc.dataSource = Constants.categories
        case 3:
            vc.isSources = true
        default:
            vc.dataSource = Constants.countries
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
