//
//  Anime+CoreDataProperties.swift
//  E-Catalogs
//
//  Created by rColeJnr on 17/08/24.
//
//

import Foundation
import CoreData


extension Anime {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Anime> {
        return NSFetchRequest<Anime>(entityName: "Anime")
    }

    @NSManaged public var animeId: Int32
    @NSManaged public var duration: String?
    @NSManaged public var image: NSURL?
    @NSManaged public var rank: Int32
    @NSManaged public var rating: String?
    @NSManaged public var source: String?
    @NSManaged public var synopsis: String?
    @NSManaged public var title: String?

}

extension Anime : Identifiable {

}
