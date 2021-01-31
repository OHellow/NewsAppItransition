//
//  News+CoreDataProperties.swift
//  NewsApp
//
//  Created by Satsishur on 30.01.2021.
//
//

import Foundation
import CoreData


extension News {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<News> {
        return NSFetchRequest<News>(entityName: "News")
    }

    @NSManaged public var descriptionArticle: String?
    @NSManaged public var publishedAt: Date?
    @NSManaged public var title: String?
    @NSManaged public var urlToImage: String?
    @NSManaged public var urlToWebsite: String?
    @NSManaged public var comments: NSSet?
    
    public var commentsArray: [Comment] {
        let set = comments as? Set<Comment> ?? []
        return set.sorted {
            ($0.text ?? "") < ($1.text ?? "")
        }
    }

}

// MARK: Generated accessors for comments
extension News {

    @objc(addCommentsObject:)
    @NSManaged public func addToComments(_ value: Comment)

    @objc(removeCommentsObject:)
    @NSManaged public func removeFromComments(_ value: Comment)

    @objc(addComments:)
    @NSManaged public func addToComments(_ values: NSSet)

    @objc(removeComments:)
    @NSManaged public func removeFromComments(_ values: NSSet)

}

extension News : Identifiable {

}
