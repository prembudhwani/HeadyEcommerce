//
//  Tax+CoreDataProperties.swift
//  HeadyEcommerce
//
//  Created by Prem Budhwani on 12/08/20.
//  Copyright © 2020 Heady. All rights reserved.
//
//

import Foundation
import CoreData


extension Tax {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tax> {
        return NSFetchRequest<Tax>(entityName: "Tax")
    }

    @NSManaged public var taxName: String?
    @NSManaged public var taxValue: Double
    @NSManaged public var taxProductInfo: Product?

}
