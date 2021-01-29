//
//  SavedNewsVC.swift
//  NewsApp
//
//  Created by Satsishur on 23.01.2021.
//

import UIKit
import CoreData

class ArchiveVC: UIViewController {
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: "cell2")
        tableView.rowHeight = 300
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    var context = CoreDataManger.sharedInstance.context
    var dataSource = CoreDataManger.sharedInstance.newsCoreData

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

extension ArchiveVC {
    func setupView() {
        view.backgroundColor = .white
        setupTableView()
        CoreDataManger.sharedInstance.loadArticles()
        dataSource = CoreDataManger.sharedInstance.newsCoreData
        tableView.reloadData()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}

extension ArchiveVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let news = dataSource[indexPath.row]
        print(news)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! ArticleTableViewCell
        cell.saveNewsButton.setImage(UIImage(systemName: "trash"), for: .normal)
        cell.buttonAction = { sender in
            let item = self.dataSource[indexPath.row]
            
            self.context.delete(item)
            do{
                try self.context.save()
            }catch _ {
            }
            CoreDataManger.sharedInstance.loadArticles()
            self.dataSource = CoreDataManger.sharedInstance.newsCoreData
            tableView.reloadData()
        }
        cell.configureFromCD(model: news)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ArticleVC()
        let savedArticle = dataSource[indexPath.row]
        let article = Article(source: nil, author: nil, title: savedArticle.title, description: savedArticle.descriptionArticle, url: savedArticle.urlToWebsite, urlToImage: savedArticle.urlToImage, publishedAt: savedArticle.publishedAt)
        vc.article = article
        vc.isArticleFromSaved = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

