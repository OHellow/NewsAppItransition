//
//  CommentsVC.swift
//  NewsApp
//
//  Created by Satsishur on 30.01.2021.
//

import UIKit

class CommentsVC: UIViewController {
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CommentsCellView.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .clear
        tableView.rowHeight = 150
        return tableView
    }()
    
    var dataSource = CoreDataManger.sharedInstance.newsCoreData
    var newsIndex = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupAddCommentButton()
    }
    
    @objc func addComment() {
        CoreDataManger.sharedInstance.addComment(index: newsIndex)
        tableView.reloadData()
    }
}

extension CommentsVC {
    func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    func setupAddCommentButton() {
        let buttonToAddComment = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addComment))
        navigationItem.setRightBarButtonItems([buttonToAddComment], animated: true)
    }
}

extension CommentsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let number = dataSource[newsIndex].comments?.count
        return number ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CommentsCellView
        let comment = self.dataSource[self.newsIndex].commentsArray[indexPath.row]
        cell.buttonAction = {
            CoreDataManger.sharedInstance.deleteComment(index: self.newsIndex, comment: comment)
            self.tableView.reloadData()
        }
        cell.configure(model: comment)
        cell.textView.delegate = self
        cell.textView.tag = indexPath.row
        return cell
    }
}

extension CommentsVC: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        let comment = self.dataSource[self.newsIndex].commentsArray[textView.tag]
        CoreDataManger.sharedInstance.updateCommentText(text: textView.text, comment: comment)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
