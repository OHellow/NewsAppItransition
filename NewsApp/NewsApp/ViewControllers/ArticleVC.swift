//
//  FullArticleVC.swift
//  NewsApp
//
//  Created by Satsishur on 20.01.2021.
//

import UIKit
import WebKit

class ArticleVC: UIViewController {
    
    private let articlePage: WKWebView = {
        let webview = WKWebView()
        webview.translatesAutoresizingMaskIntoConstraints = false
        return webview
    }()
    
    var article: Article?
    var isArticleFromSaved = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadRequest()
    }
    
    func setupView() {
        setupArticlePage()
        setupNavigationBarButtons()
    }
    
    func setupArticlePage() {
        view.addSubview(articlePage)
        articlePage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        articlePage.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        articlePage.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        articlePage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func setupNavigationBarButtons() {
        let buttonToSaveArticle = UIBarButtonItem(image: UIImage(systemName: "bookmark.circle"), style: .plain, target: self, action: #selector(saveArticle))
        let buttonToShareArticle = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareArticle))
        var buttons = [UIBarButtonItem]()
        if !isArticleFromSaved {
            buttons.append(buttonToSaveArticle)
        }
        buttons.append(buttonToShareArticle)

        navigationItem.setRightBarButtonItems(buttons, animated: true)
    }
    
    func loadRequest() {
        guard let urlString = article?.url, let url = URL(string: urlString) else {return}
        let request = URLRequest(url: url)
        articlePage.load(request)
    }
    
    @objc func saveArticle() {
        //print(1)
        guard let article = self.article else {return}
        CoreDataManger.sharedInstance.saveArticle(article: article)
    }
    
    @objc func shareArticle() {
        //print(2)
        guard let urlString = article?.url, let urlFromArticle = URL(string: urlString) else {return}
        let url = urlFromArticle
        let textShare = [url]
        let activityViewController = UIActivityViewController(activityItems: textShare as [Any] , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    

}
