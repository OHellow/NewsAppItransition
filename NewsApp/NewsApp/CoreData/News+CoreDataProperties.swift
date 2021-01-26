//
//  News+CoreDataProperties.swift
//  NewsApp
//
//  Created by Satsishur on 23.01.2021.
//
//

import Foundation
import CoreData


extension News {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<News> {
        return NSFetchRequest<News>(entityName: "News")
    }

    @NSManaged public var title: String?
    @NSManaged public var descriptionArticle: String?
    @NSManaged public var publishedAt: Date?
    @NSManaged public var urlToImage: String?
    @NSManaged public var urlToWebsite: String?

}

extension News : Identifiable {

}
