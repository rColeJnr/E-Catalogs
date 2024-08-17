//
//  MovieResponse+CoreDataProperties.swift
//  E-Catalogs
//
//  Created by rColeJnr on 15/08/24.
//
//

import Foundation
import CoreData


extension MovieResponse {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieResponse> {
        return NSFetchRequest<MovieResponse>(entityName: "MovieResponse")
    }

    @NSManaged public var page: Int16
    @NSManaged public var movieId: Int64
    @NSManaged public var title: String?
    @NSManaged public var image: NSURL?
    @NSManaged public var overview: String?

}

extension MovieResponse : Identifiable {

}
