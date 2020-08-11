//
//  Ranking+CoreDataProperties.swift
//  HeadyEcommerce
//
//  Created by Prem Budhwani on 11/08/20.
//  Copyright © 2020 Heady. All rights reserved.
//
//

import Foundation
import CoreData


extension Ranking {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ranking> {
        return NSFetchRequest<Ranking>(entityName: "Ranking")
    }

    @NSManaged public var rankingName: String?

}
