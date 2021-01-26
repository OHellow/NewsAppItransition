//
//  CategoryVC.swift
//  NewsApp
//
//  Created by Satsishur on 23.01.2021.
//

import UIKit

protocol CategoryProtocol {
    func getCategory(category: String)
}

class CategoryVC: UIViewController {
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    var articleManager = ArticlesManager()
    var dataSource = [String]()
    var isSources = false
    var delegate: CategoryProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        if isSources {
            guard let url = articleManager.requestSources() else {return}
            articleManager.getPublishers(from: url) { (publishers) in
                for publisher in publishers {
                    self.dataSource.append(publisher.id ?? "no info")
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension CategoryVC {
    func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

extension CategoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.getCategory(category: dataSource[indexPath.row])
        navigationController?.popViewController(animated: true)
    }
}