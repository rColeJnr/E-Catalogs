//
//  Anime+CoreDataProperties.swift
//  E-Catalogs
//
//  Created by rColeJnr on 16/08/24.
//
//

import Foundation
import CoreData


extension Anime {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Anime> {
        return NSFetchRequest<Anime>(entityName: "Anime")
    }

    @NSManaged public var animeId: Int32
    @NSManaged public var images: AnimeImage?
    @NSManaged public var title: String?
    @NSManaged public var source: String?
    @NSManaged public var episodes: Int32
    @NSManaged public var airing: Bool
    @NSManaged public var aired: AnimeAired?
    @NSManaged public var duration: String?
    @NSManaged public var rating: String?
    @NSManaged public var rank: Int32
    @NSManaged public var popularity: Int32
    @NSManaged public var synopsis: String?
    @NSManaged public var background: String?
    @NSManaged public var genres: [AnimeGenre]?

}

extension Anime : Identifiable {

}
