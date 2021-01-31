//
//  HomeVC+TableDataSource.swift
//  NewsApp
//
//  Created by Satsishur on 31.01.2021.
//

import UIKit

extension HomeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let searchOption = Options.search.rawValue
        return segmentedControl.selectedSegmentIndex != searchOption ? 44 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? HeaderCellView ?? HeaderCellView(reuseIdentifier: "header")
        header.titleLabel.text = headerTitle
        header.delegate = self
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ArticleTableViewCell
        let model = dataSource[indexPath.row]
        cell.buttonAction = {
            //print(indexPath.row)
            let article = self.dataSource[indexPath.row]
            CoreDataManger.sharedInstance.saveArticle(article: article)
            }
        cell.configure(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = self.dataSource.count - 1
        if !self.isSearching && self.noAvaiableNews == false && indexPath.row == lastElement {
            requestMoreNews()
        }
    }
    
    func requestMoreNews() {
        self.page += 1
        print("PAGE NUMBER \(page)")
        requestNews()
    }
    
    func requestNews() {
        self.isSearching = true
        switch segmentedControl.selectedSegmentIndex {
        case Options.search.rawValue:
            downloadNews(endpoint: endpoint, filter: filter, page: String(page))
        case Options.category.rawValue:
            downloadNews(endpoint: endpoint, category: category, page: String(page))
        case Options.source.rawValue:
            downloadNews(endpoint: endpoint, source: source, page: String(page))
        default:
            downloadNews(endpoint: endpoint, country: country, page: String(page))
        }
    }
}

extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ArticleVC()
        vc.article = dataSource[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
