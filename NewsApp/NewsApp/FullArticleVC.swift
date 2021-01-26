//
//  FullArticleVC.swift
//  NewsApp
//
//  Created by Satsishur on 20.01.2021.
//

import UIKit
import WebKit

class FullArticleVC: UIViewController {
    
    private let articlePage: WKWebView = {
        let webview = WKWebView()
        webview.translatesAutoresizingMaskIntoConstraints = false
        return webview
    }()
    
    var url: URL? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        if let url = url {
          let request = URLRequest(url: url)
          articlePage.load(request)
        }
    }
    
    func setupView() {
        view.addSubview(articlePage)
        articlePage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        articlePage.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        articlePage.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        articlePage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}
