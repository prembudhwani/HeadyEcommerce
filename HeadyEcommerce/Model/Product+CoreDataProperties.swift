//
//  Product+CoreDataProperties.swift
//  HeadyEcommerce
//
//  Created by Prem Budhwani on 12/08/20.
//  Copyright © 2020 Heady. All rights reserved.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var productDateAdded: String?
    @NSManaged public var productId: Int64
    @NSManaged public var productName: String?
    @NSManaged public var productOrderCount: Int64
    @NSManaged public var productShareCount: Int64
    @NSManaged public var productViewCount: Int64
    @NSManaged public var productCategoryInfo: Category?
    @NSManaged public var productTaxInfo: Tax?
    @NSManaged public var productVariantInfo: NSSet?

}

// MARK: Generated accessors for productVariantInfo
extension Product {

    @objc(addProductVariantInfoObject:)
    @NSManaged public func addToProductVariantInfo(_ value: Variant)

    @objc(removeProductVariantInfoObject:)
    @NSManaged public func removeFromProductVariantInfo(_ value: Variant)

    @objc(addProductVariantInfo:)
    @NSManaged public func addToProductVariantInfo(_ values: NSSet)

    @objc(removeProductVariantInfo:)
    @NSManaged public func removeFromProductVariantInfo(_ values: NSSet)

}
