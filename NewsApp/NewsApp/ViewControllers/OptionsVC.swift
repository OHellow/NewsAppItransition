//
//  CategoryVC.swift
//  NewsApp
//
//  Created by Satsishur on 23.01.2021.
//

import UIKit

class OptionsVC: UIViewController {
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    var articleManager = NetworkService()
    let url_constructor = URL_Constructor()
    var dataSource = [String]()
    var isSources = false
    var delegate: GetOptionProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        if isSources {
            fetchSources()
        }
    }
    
    func fetchSources() {
        guard let url = url_constructor.requestSources() else {return}
        articleManager.fetchSources(from: url) { (result) in
            switch result {
            case .success(let publishers):
                for publisher in publishers {
                    self.dataSource.append(publisher.id ?? "no info")
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(.networkingError):
                print("ERROR")
            }
        }
    }
}

extension OptionsVC {
    func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

extension OptionsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.getOption(option: dataSource[indexPath.row])
        navigationController?.popViewController(animated: true)
    }
}
