//
//  CoreDataManager.swift
//  NewsApp
//
//  Created by Satsishur on 23.01.2021.
//

import UIKit
import CoreData

class CoreDataManger {
    // MARK: - Properties
    static let sharedInstance = CoreDataManger()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let notificationCenter = NotificationCenter.default
    var newsCoreData: [News] = []
    
    // MARK: - Lifecycle
    
    private init() {}
    
    func saveArticle(article: Article) {
        let news = News(context: context)
        news.setValue("\(article.articleDescription ?? "")", forKeyPath: "descriptionArticle")
        news.setValue(article.publishedAt, forKeyPath: "publishedAt")
        news.setValue("\(article.title ?? "")", forKeyPath: "title")
        news.setValue("\(article.urlToImage ?? "")", forKeyPath: "urlToImage")
        news.setValue("\(article.url ?? "")", forKeyPath: "urlToWebsite")
        
        saveContext()
        notificationCenter.post(name: Notification.Name("ArticleSaved"), object: nil)
        print("SAVED")
    }
    
    func loadArticles() {
        do {
            let request = News.fetchRequest() as NSFetchRequest<News>
            
            let sortDescriptor = NSSortDescriptor(key: "publishedAt", ascending: true)
            request.sortDescriptors = [sortDescriptor]
            
            self.newsCoreData = try context.fetch(request)
            print("NEWS CORE DATA",self.newsCoreData)
        } catch {
            print("ERROR",error.localizedDescription)
        }
    }
    
    func addComment(index: Int) {
        let news = newsCoreData[index]
        let comment = Comment(context: context)
        
        news.addToComments(comment)
        
        saveContext()
    }
    
    func deleteComment(index: Int, comment: Comment) {
        let news = newsCoreData[index]
        news.removeFromComments(comment)
        
        saveContext()
    }
    
    func updateCommentText(text: String, comment: Comment) {
        comment.setValue(text, forKeyPath: "text")

        saveContext()
    }
    
    func saveContext() {
        do {
          try context.save()
        } catch let error {
          print("Failed to create Person: \(error.localizedDescription)")
        }
    }
}
