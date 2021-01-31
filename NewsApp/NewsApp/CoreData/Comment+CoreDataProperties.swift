//
//  Comment+CoreDataProperties.swift
//  NewsApp
//
//  Created by Satsishur on 30.01.2021.
//
//

import Foundation
import CoreData


extension Comment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Comment> {
        return NSFetchRequest<Comment>(entityName: "Comment")
    }

    @NSManaged public var text: String?
    @NSManaged public var news: News?

}

extension Comment : Identifiable {

}
