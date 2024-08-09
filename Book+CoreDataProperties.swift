//
//  Book+CoreDataProperties.swift
//  E-Catalogs
//
//  Created by rColeJnr on 09/08/24.
//
//

import Foundation
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var isbn10: String?
    @NSManaged public var rank: Int16
    @NSManaged public var rankLastWeek: Int16
    @NSManaged public var weeksOnLIst: Int16
    @NSManaged public var bookDescription: String?
    @NSManaged public var title: String?
    @NSManaged public var author: String?
    @NSManaged public var image: NSURL?
    @NSManaged public var amazonLiink: NSURL?

}

extension Book : Identifiable {

}
