//
//  Book+CoreDataProperties.swift
//  E-Catalogs
//
//  Created by rColeJnr on 12/08/24.
//
//

import Foundation
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var amazonLiink: NSURL?
    @NSManaged public var author: String?
    @NSManaged public var bookDescription: String?
    @NSManaged public var image: NSURL?
    @NSManaged public var isbn10: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var rank: Int16
    @NSManaged public var rankLastWeek: Int16
    @NSManaged public var title: String?
    @NSManaged public var weeksOnLIst: Int16

}

extension Book : Identifiable {

}
