//
//  ArticleVC.swift
//  NewsApp
//
//  Created by Satsishur on 18.01.2021.
//

import UIKit
import CoreData

class ArticleVC: UIViewController {
    // MARK: - View items
    private let segmentedControl: UISegmentedControl = {
        let itemsForSegments = ["Countries", "Search", "Category", "Source"]
        let sc = UISegmentedControl(items: itemsForSegments)
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    private let switchTopHeadlines: UISwitch = {
        let _switch = UISwitch()
        _switch.translatesAutoresizingMaskIntoConstraints = false
        _switch.isOn = true
        return _switch
    }()
    
    let stackView = UIStackView()
    let switchView = UIView()
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 300
//        tableView.estimatedRowHeight = 250
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private var searchController = UISearchController(searchResultsController: nil)
    
    //MARK: Properties
    private var page: Int = 1
    private var query: String = ""
    var category: String = "general"
    var country: String = {
        let locale = Locale.current.regionCode
        let country = locale
        return country ?? "us"
    }()
    var source: String = "bbc-news"
    var endpoint: Endpoint = .topHeadLines
    var headerTitle = ""
    
    private var isSearching: Bool = false
    
    let articleManager = ArticlesManager()
    var dataSource = [Article]()

    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        downloadNews(endpoint: endpoint, country: country, page: String(page))
        
        //searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search News"
        navigationItem.searchController = nil
        navigationItem.title = "news"
    }
    //MARK: Methods
    func downloadNews(endpoint: Endpoint, country: String? = nil, category: String? = nil, source: String? = nil, filter: String? = nil, page: String? = nil) {
        guard let url = articleManager.requestNews(endpoint: endpoint, country: country, category: category, source: source, filter: filter, page: page) else {return}
        print(url)
        articleManager.getResults(from: url) { (articles) in
            DispatchQueue.main.async {
                print(articles.count)
                self.dataSource.append(contentsOf: articles)
                //print("DATA SOURCE", self.dataSource.count)
                self.tableView.reloadData()
                self.isSearching = false
            }
        }
    }
    
    func getEndpoint() {
        if segmentedControl.selectedSegmentIndex == 1 {
            switchView.isHidden = true
            navigationItem.searchController = searchController
            endpoint = .search
            page = 1
            dataSource.removeAll()
            tableView.reloadData()
        } else {
            var _country: String? = nil
            var _category: String? = nil
            var _source: String? = nil
            switch segmentedControl.selectedSegmentIndex {
            case 2:
                switchView.isHidden = true
                navigationItem.searchController = nil
                headerTitle = category
                endpoint = .topHeadLines
                _category = category
            case 3:
                switchView.isHidden = false
                navigationItem.searchController = nil
                headerTitle = source
                endpoint = .topHeadLines
                _source = source
            default:
                switchView.isHidden = true
                navigationItem.searchController = nil
                headerTitle = country
                endpoint = .topHeadLines
                _country = country
            }
            if switchTopHeadlines.isOn {
                endpoint = .topHeadLines
            }
            page = 1
            dataSource.removeAll()
            tableView.reloadData()
            downloadNews(endpoint: endpoint, country: _country, category: _category, source: _source, page: String(page))
        }
    }
    //MARK: Selector
    @objc func changeNews(sender: UISegmentedControl) {
        getEndpoint()
    }
    
    @objc func switchChanged(sender: UISegmentedControl) {
        getEndpoint()
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let scroll = scrollView.contentSize.height - scrollView.contentOffset.y
//        if scroll <=  2 * scrollView.bounds.height {
//            requestMoreNews()
//            print(1)
//        }
//    }
}
//MARK: SetupView
extension ArticleVC {
    func setupView() {
        view.backgroundColor = .white
        setupSubviews()
        setupStack()
        setupSwitchView()
        setupTableView()
    }
    
    func setupSubviews() {
        view.addSubview(stackView)
        view.addSubview(tableView)
        view.addSubview(searchController.searchBar)
    }
    
    func setupStack() {
        view.addSubview(segmentedControl)
        segmentedControl.sizeToFit()
        segmentedControl.addTarget(self, action: #selector(changeNews(sender:)), for: .valueChanged)
        view.addSubview(switchView)
        switchView.sizeToFit()
        switchView.backgroundColor = .green
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        [segmentedControl, switchView].forEach { stackView.addArrangedSubview($0) }
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        //stackView.heightAnchor.constraint(equalToConstant: 75).isActive = true
    }
    
    func setupSwitchView() {
        switchView.addSubview(switchTopHeadlines)
        switchTopHeadlines.topAnchor.constraint(equalTo: switchView.topAnchor, constant: 3).isActive = true
        switchTopHeadlines.bottomAnchor.constraint(equalTo: switchView.bottomAnchor, constant: -3).isActive = true
        switchTopHeadlines.rightAnchor.constraint(equalTo: switchView.rightAnchor, constant: -3).isActive = true
        switchTopHeadlines.centerYAnchor.constraint(equalTo: switchView.centerYAnchor).isActive = true
        switchTopHeadlines.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)

        let text = UILabel()
        switchView.addSubview(text)
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = "Top Headlines"
        text.font = UIFont.systemFont(ofSize: 16)
        text.centerYAnchor.constraint(equalTo: switchView.centerYAnchor).isActive = true
        text.leftAnchor.constraint(equalTo: switchView.leftAnchor, constant: 5).isActive = true
        
        switchView.isHidden = true
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}
//MARK: TableView methods
extension ArticleVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return segmentedControl.selectedSegmentIndex != 1 ? 44 : 0
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
        cell.buttonAction = { sender in
            print(indexPath.row)
            let article = self.dataSource[indexPath.row]
            CoreDataManger.sharedInstance.saveArticle(article: article)
            }
        cell.configure(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(0)
        let vc = FullArticleVC()
        vc.url = URL(string: dataSource[indexPath.row].url ?? "") 
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ArticleVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchBar = searchController.searchBar
        guard let text = searchBar.text else {return}
        query = text
        guard let url = articleManager.requestNews(endpoint: .search, filter: text, page: String(page)) else {return}
        articleManager.getResults(from: url) { (articles) in
            DispatchQueue.main.async {
                //print(articles)
                self.dataSource.removeAll()
                self.dataSource = articles
                self.tableView.reloadData()
            }
        }
    }
    
//    func updateSearchResults(for searchController: UISearchController) {
//        let searchBar = searchController.searchBar
//        guard let text = searchBar.text else {return}
//        query = text
//        guard let url = articleManager.requestNews(endpoint: .search, filter: text, page: String(page)) else {return}
//        articleManager.getResults(from: url) { (articles) in
//            DispatchQueue.main.async {
//                //print(articles)
//                self.dataSource.removeAll()
//                self.dataSource = articles
//                self.tableView.reloadData()
//            }
//        }
//    }
}

extension ArticleVC {
    func requestMoreNews() {
        if  !isSearching {
            page += 1
            print("PAGE NUMBER \(page)")
            requestNews()
        }
    }
    
    func requestNews() {
        isSearching = true
        switch segmentedControl.selectedSegmentIndex {
        case 1:
            downloadNews(endpoint: endpoint, filter: query, page: String(page))
        case 2:
            downloadNews(endpoint: endpoint, category: category, page: String(page))
        case 3:
            downloadNews(endpoint: endpoint, source: source, page: String(page))
        default:
            downloadNews(endpoint: endpoint, country: country, page: String(page))
        }
    }
}

extension ArticleVC: HeaderDelegate {
    func getTitles() {
        let vc = CategoryVC()
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

extension ArticleVC: CategoryProtocol {
    func getCategory(category: String) {
        print(category)
        switch segmentedControl.selectedSegmentIndex {
        case 2:
            self.category = category
        case 3:
            self.source = category
        default:
            self.country = category
        }
        headerTitle = category
        getEndpoint()
    }
}
