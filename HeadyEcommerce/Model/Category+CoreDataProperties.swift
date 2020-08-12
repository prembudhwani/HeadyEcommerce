//
//  Category+CoreDataProperties.swift
//  HeadyEcommerce
//
//  Created by Prem Budhwani on 12/08/20.
//  Copyright © 2020 Heady. All rights reserved.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var categoryId: Int64
    @NSManaged public var categoryName: String?
    @NSManaged public var categoryProductsInfo: NSSet?
    @NSManaged public var subCategoryInfo: NSSet?

}

// MARK: Generated accessors for categoryProductsInfo
extension Category {

    @objc(addCategoryProductsInfoObject:)
    @NSManaged public func addToCategoryProductsInfo(_ value: Product)

    @objc(removeCategoryProductsInfoObject:)
    @NSManaged public func removeFromCategoryProductsInfo(_ value: Product)

    @objc(addCategoryProductsInfo:)
    @NSManaged public func addToCategoryProductsInfo(_ values: NSSet)

    @objc(removeCategoryProductsInfo:)
    @NSManaged public func removeFromCategoryProductsInfo(_ values: NSSet)

}

// MARK: Generated accessors for subCategoryInfo
extension Category {

    @objc(addSubCategoryInfoObject:)
    @NSManaged public func addToSubCategoryInfo(_ value: Category)

    @objc(removeSubCategoryInfoObject:)
    @NSManaged public func removeFromSubCategoryInfo(_ value: Category)

    @objc(addSubCategoryInfo:)
    @NSManaged public func addToSubCategoryInfo(_ values: NSSet)

    @objc(removeSubCategoryInfo:)
    @NSManaged public func removeFromSubCategoryInfo(_ values: NSSet)

}
