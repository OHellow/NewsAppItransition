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
  
  var newsCoreData: [News] = []
  //var article = Article()
  
  // MARK: - Lifecycle
  
  private init() {}
  
  // MARK: - Core Data Saving support
  
  /// Saves an ArticlesData object as a News object
  func saveArticle(article: Article) {
    
    // Create an new 'News' object
    let news = News(context: context)
    news.setValue("\(article.description ?? "")", forKeyPath: "descriptionArticle")
    news.setValue(article.publishedAt, forKeyPath: "publishedAt")
    news.setValue("\(article.title ?? "")", forKeyPath: "title")
    news.setValue("\(article.urlToImage ?? "")", forKeyPath: "urlToImage")
    news.setValue("\(article.url ?? "")", forKeyPath: "urlToWebsite")
    // Save to CoreData
    do {
      try context.save()
        print("CORE DATA SAVED")
    } catch let error {
      print("Failed to create Person: \(error.localizedDescription)")
    }
  }
  
    func loadArticles() {//-> NSFetchRequest<NSFetchRequestResult>{
         //let fetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "News")
        do {
         let request = News.fetchRequest() as NSFetchRequest<News>
         //fetchRequest.fetchLimit = newsCoreData.count

         let sortDescriptor = NSSortDescriptor(key: "publishedAt", ascending: true)
        request.sortDescriptors = [sortDescriptor]

        self.newsCoreData = try context.fetch(request)
            print("NEWS CORE DATA",self.newsCoreData)
        } catch {
            print("ERROR",error.localizedDescription)
        }
    }
    
  /// Prints the Core Data path and can be viewed in Finder
  func printCoreDataDBPath() {
    let path = FileManager
      .default
      .urls(for: .applicationSupportDirectory, in: .userDomainMask)
      .last?
      .absoluteString
      .replacingOccurrences(of: "file://", with: "")
      .removingPercentEncoding
    print("Core Data DB Path: \(path ?? "Not found")")
  }
}
