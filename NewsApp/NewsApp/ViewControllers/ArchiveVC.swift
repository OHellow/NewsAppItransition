//
//  SavedNewsVC.swift
//  NewsApp
//
//  Created by Satsishur on 23.01.2021.
//

import UIKit
import CoreData

class ArchiveVC: UIViewController {
    //MARK: Views
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: "cell2")
        tableView.rowHeight = 300
        tableView.backgroundColor = .clear
        return tableView
    }()
    //MARK: Properties
    var context = CoreDataManger.sharedInstance.context
    var dataSource = CoreDataManger.sharedInstance.newsCoreData
    let nc = NotificationCenter.default
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadArticlesFromCD()
        nc.addObserver(self, selector: #selector(updateTableView), name: Notification.Name("ArticleSaved"), object: nil)
    }
    //MARK: Methods
    func loadArticlesFromCD() {
        CoreDataManger.sharedInstance.loadArticles()
        dataSource = CoreDataManger.sharedInstance.newsCoreData
        tableView.reloadData()
    }
    //MARK: Selectors
    @objc func updateTableView() {
        loadArticlesFromCD()
    }
}
    //MARK: Setup View Layout
extension ArchiveVC {
    func setupView() {
        view.backgroundColor = .white
        setupTableView()
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
    //MARK: TableView DataSource
extension ArchiveVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let news = dataSource[indexPath.row]
        print(news)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! ArticleTableViewCell
        cell.saveNewsButton.setImage(UIImage(systemName: "trash"), for: .normal)
        cell.commentsButton.isHidden = false
        cell.buttonAction = { 
            let item = self.dataSource[indexPath.row]
            
            self.context.delete(item)
            do{
                try self.context.save()
            }catch _ {
            }
            self.updateTableView()
        }
        cell.buttonCommentAction = {
            let isUsingPassword = UserDefaults.standard.bool(forKey: "usePassword")
            if (isUsingPassword) == true {
                Alerts.showEnterPasswordAlert(viewController: self, titleMessage: "Password", message: "Enter password") { (result) in
                    if result {
                        self.navigateToCommentsVC(indexOfCell: indexPath.row)
                    } else {
                        Alerts.showMessageAlert(viewController: self, titleMessage: "Wrong password", message: "Try to re-enter or change password")
                    }
                }
            } else {
                self.navigateToCommentsVC(indexOfCell: indexPath.row)
            }
        }
        cell.configureFromCD(model: news)
        return cell
    }
    
    func navigateToCommentsVC(indexOfCell: Int) {
        let vc = CommentsVC()
        vc.newsIndex = indexOfCell
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ArchiveVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ArticleVC()
        let savedArticle = dataSource[indexPath.row]
        let article = Article(source: nil, author: nil, title: savedArticle.title, articleDescription: savedArticle.descriptionArticle, url: savedArticle.urlToWebsite, urlToImage: savedArticle.urlToImage, publishedAt: savedArticle.publishedAt)
        vc.article = article
        vc.isArticleFromSaved = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

