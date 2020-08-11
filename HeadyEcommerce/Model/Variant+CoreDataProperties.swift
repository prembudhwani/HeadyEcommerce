//
//  Variant+CoreDataProperties.swift
//  HeadyEcommerce
//
//  Created by Prem Budhwani on 11/08/20.
//  Copyright © 2020 Heady. All rights reserved.
//
//

import Foundation
import CoreData


extension Variant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Variant> {
        return NSFetchRequest<Variant>(entityName: "Variant")
    }

    @NSManaged public var variantColor: String?
    @NSManaged public var variantId: Int64
    @NSManaged public var variantPrice: Double
    @NSManaged public var variantSize: String?
    @NSManaged public var variantProductInfo: Product?

}
