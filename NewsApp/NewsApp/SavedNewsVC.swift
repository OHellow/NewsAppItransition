//
//  SavedNewsVC.swift
//  NewsApp
//
//  Created by Satsishur on 23.01.2021.
//

import UIKit
import CoreData

class SavedNewsVC: UIViewController {
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: "cell2")
        tableView.rowHeight = 300
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    var context = CoreDataManger.sharedInstance.context
    var newsData = CoreDataManger.sharedInstance.newsCoreData
//    var fetchRequest = CoreDataManger.sharedInstance.loadArticles()
//    var fetchedResultController:NSFetchedResultsController = NSFetchedResultsController<NSFetchRequestResult>()

    override func viewDidLoad() {
        super.viewDidLoad()
//        fetchedResultController = getResultFetchedResultController()
//        fetchedResultController.delegate = self
        setupView()
        
    }
    
//    func getResultFetchedResultController()->NSFetchedResultsController<NSFetchRequestResult>{
//        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
//        return fetchedResultController
//    }
}

extension SavedNewsVC {
    func setupView() {
        view.backgroundColor = .white
        setupTableView()
        CoreDataManger.sharedInstance.loadArticles()
        newsData = CoreDataManger.sharedInstance.newsCoreData
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

extension SavedNewsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(fetchedResultController.sections?[section].numberOfObjects)
        //print(newsData.count)
        return newsData.count//fetchedResultController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let news = newsData[indexPath.row]//fetchedResultController.object(at: indexPath as IndexPath) as! News
        //let news = fetchedResultController.object(at: indexPath as IndexPath) as! News
        print(news)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! ArticleTableViewCell
        
        cell.buttonAction = { sender in
            //print(indexPath.row)
            let item = self.newsData[indexPath.row]
            
            self.context.delete(item)
            do{
                try self.context.save()
            }catch _ {
            }
            CoreDataManger.sharedInstance.loadArticles()
            self.newsData = CoreDataManger.sharedInstance.newsCoreData
            tableView.reloadData()
        }
        cell.configureFromCD(model: news)
        return cell
    }
}

//extension SavedNewsVC: NSFetchedResultsControllerDelegate {
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.reloadData()
//    }
//}
