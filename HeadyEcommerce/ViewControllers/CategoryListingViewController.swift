//
//  CategoryListingViewController.swift
//  HeadyEcommerce
//
//  Created by Prem Budhwani on 10/08/20.
//  Copyright © 2020 Heady. All rights reserved.
//

import UIKit
import CoreData

class CategoryListingViewController: UIViewController , UITableViewDataSource ,UITableViewDelegate {
    
    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var loaderView: UIActivityIndicatorView!
    
    var arrCategories : [Category] = []
    var titleToDisplay : String = "Products"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = self.titleToDisplay
        self.categoryTableView.tableFooterView = UIView()
        self.loaderView.isHidden = true         //Default hidden
        
        if (self.arrCategories.count == 0)
        {
            self.loaderView.isHidden = false
            
            //Hit the web API to fetch data from server
            let service = WebAPIService()
            service.getDataWith { (result) in
                switch result {
                case .Success(let data):
                    print(data)
                    self.clearAllData()
                    self.writeAllResponseToCoreData(dictionary: data)
                    
                    do {
                        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
                        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Category.self))
                        do {
                            self.arrCategories  = try context.fetch(fetchRequest) as! [Category]
                            self.categoryTableView.reloadData()
                            self.loaderView.isHidden = true
                            
                            print("=================================================================")
                            print(self.arrCategories)
                            print("=================================================================")
                            
                        } catch let error {
                            print("ERROR FETCHING CATEGORIES : \(error)")
                        }
                    }
                    
                case .Error(let message):
                    DispatchQueue.main.async {
                        self.loaderView.isHidden = true
                        self.showAlertWith(title: "Error", message: message)
                    }
                }
            }
        }
    }

    
    func showAlertWith(title: String, message: String, style: UIAlertController.Style = .alert) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: title, style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //Method to clear all the entities from Core Data
    private func clearAllData() {
        self.clearTaxData()
        self.clearVariantData()
        self.clearProductData()
        self.clearCategoryData()
        self.clearRankingData()
    }
    
    //Method to clear Tax entities from Core Data
    private func clearTaxData() {
        do {
            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Tax.self))
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                CoreDataStack.sharedInstance.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }

    //Method to clear Variant entities from Core Data
    private func clearVariantData() {
        do {
            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Variant.self))
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                CoreDataStack.sharedInstance.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }

    //Method to clear Product entities from Core Data
    private func clearProductData() {
        do {
            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Product.self))
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                CoreDataStack.sharedInstance.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }

    //Method to clear Category entities from Core Data
    private func clearCategoryData() {
        do {
            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Category.self))
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                CoreDataStack.sharedInstance.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
    
    //Method to clear Ranking entities from Core Data
    private func clearRankingData() {
        do {
            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Ranking.self))
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                CoreDataStack.sharedInstance.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }

    private func writeAllResponseToCoreData(dictionary: [String: AnyObject])
    {
        let categoriesArray = dictionary["categories"] as! [[NSString : AnyObject]]
        
        //In first pass, create Categories, and don't include sub-categories
        self.saveCategoriesInCoreDataWith(array: categoriesArray as [[String : AnyObject]])
        
        //In second pass, check where "child_categories" exist. If exist anywhere, then create mappings of "child_categories" to it's main category
        self.createSubCategoriesMappings(array: categoriesArray as [[String : AnyObject]])
        
        //In third pass, create "Rankings" and accordingly set the view_count, order_count and share_count of each product
        let rankingsArray = dictionary["rankings"] as! [[NSString : AnyObject]]
        self.saveRankingsInCoreDataWith(array: rankingsArray as [[String : AnyObject]])
    }
    
    //Method to save dictionary elements of Categories array, to the CoreData
    private func saveCategoriesInCoreDataWith(array: [[String: AnyObject]]) {
        _ = array.map{self.createCategoryEntityFrom(dictionary: $0)}
        do {
            try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
            print("PREM TESTING... Categories data saved to Core Data")
        } catch let error {
            print(error)
        }
    }
    
    //Method to create subCategories mappings
    private func createSubCategoriesMappings(array: [[String : AnyObject]])
    {
        let filteredArray = array.filter { $0["child_categories"] != nil &&  ($0["child_categories"]?.count)! > 0}
        
        if (filteredArray.count > 0)        //There are some categories which are having "child_categories" data
        {
            //Create mappings of subcategories for only these categories which are having "child_categories"
            for categoryObj in filteredArray
            {
                let categoryId = categoryObj["id"] as! Int64
                let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
                let fetchRequest1 = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Category.self))
                fetchRequest1.predicate = NSPredicate(format: "categoryId == %ld", categoryId)
                do {
                    let srcCategoryObject = try (context.fetch(fetchRequest1) as? [Category])?.first
                    
                    let childCategoryIdsArray = categoryObj["child_categories"]
                    let fetchRequest2 = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Category.self))
                    fetchRequest2.predicate = NSPredicate(format: "categoryId IN %@", childCategoryIdsArray as! CVarArg)
                    do {
                        let childCategoriesObjects = try context.fetch(fetchRequest2) as? [Category]
                        let subCategoriesInfo = NSSet(array: childCategoriesObjects!)
                        srcCategoryObject?.addToSubCategoryInfo(subCategoriesInfo)
                    } catch let error {
                        print("ERROR FETCHING CHILD CATEGORIES: \(error)")
                    }
                } catch let error {
                    print("ERROR FETCHING SOURCE CATEGORY: \(error)")
                }
            }
        }
    }
    
    //Method to create a Tax entity in Core Data
    private func createTaxEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let taxEntity = NSEntityDescription.insertNewObject(forEntityName: "Tax", into: context) as? Tax {
            taxEntity.taxName = dictionary["name"] as? String
            taxEntity.taxValue = dictionary["value"] as? Double ?? 0
            return taxEntity
        }
        return nil
    }

    //Method to create a Variant entity in Core Data
    private func createVariantEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let variantEntity = NSEntityDescription.insertNewObject(forEntityName: "Variant", into: context) as? Variant {
            variantEntity.variantId = dictionary["id"] as? Int64 ?? 0
            variantEntity.variantColor = dictionary["color"] as? String
            if let varSize = dictionary["size"]
            {
                if (varSize is String)
                {
                    variantEntity.variantSize = (varSize as! String)
                }
                else if (varSize is Int)
                {
                    variantEntity.variantSize = "\(varSize)"
                }
            }
            else
            {
                variantEntity.variantSize = "N/A"
            }
            
            variantEntity.variantPrice = dictionary["price"] as? Double ?? 0
            return variantEntity
        }
        return nil
    }

    //Method to create a Product entity in Core Data
    private func createProductEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let productEntity = NSEntityDescription.insertNewObject(forEntityName: "Product", into: context) as? Product {
            productEntity.productId = dictionary["id"] as? Int64 ?? 0
            productEntity.productName = dictionary["name"] as? String
            productEntity.productDateAdded = dictionary["date_added"] as? String

            if let taxobj = dictionary["tax"]
            {
                productEntity.productTaxInfo = self.createTaxEntityFrom(dictionary: taxobj as! [String : AnyObject]) as? Tax
            }

            if let variants = dictionary["variants"]
            {
                let variantsArray = variants as! NSArray
                if variantsArray.count > 0
                {
                    for dict in variantsArray {
                        let variantObj = self.createVariantEntityFrom(dictionary: dict as! [String : AnyObject]) as! Variant
                        productEntity.addToProductVariantInfo(variantObj)
                    }
                }
            }
            return productEntity
        }
        return nil
    }
    
    //Method to create a Category entity in Core Data
    private func createCategoryEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let categoryEntity = NSEntityDescription.insertNewObject(forEntityName: "Category", into: context) as? Category
        {
            categoryEntity.categoryId = dictionary["id"] as? Int64 ?? 0
            categoryEntity.categoryName = dictionary["name"] as? String
            

            if let products = dictionary["products"]
            {
                let productsArray = products as! NSArray
                if productsArray.count > 0
                {
                    for dict in productsArray {
                        let productObj = self.createProductEntityFrom(dictionary: dict as! [String : AnyObject]) as! Product
                        categoryEntity.addToCategoryProductsInfo(productObj)
                    }
                    CoreDataStack.sharedInstance.saveContext()
                }
            }

            return categoryEntity
        }
        return nil
    }
    
    
    //Method to save dictionary elements of Rankings array, to the CoreData
    private func saveRankingsInCoreDataWith(array: [[String: AnyObject]]) {
        _ = array.map{self.createRankingEntityFrom(dictionary: $0)}
        do {
            try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
            print("PREM TESTING... Rankings data saved to Core Data")
        } catch let error {
            print(error)
        }
    }
    
    //Method to create a Ranking entity in Core Data
    private func createRankingEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let rankingEntity = NSEntityDescription.insertNewObject(forEntityName: "Ranking", into: context) as? Ranking
        {
            rankingEntity.rankingName = dictionary["ranking"] as? String
            
            //Set different counts for this ranking for each product that comes under this ranking
            if let products = dictionary["products"]
            {
                let productsArray = products as! [[String : AnyObject]]
                if productsArray.count > 0
                {
                    //Update relevant count (i.e. productOrderCount, productViewCount, productShareCount) of the product
                    for productObj in productsArray
                    {
                        let productId = productObj["id"] as! Int64
                        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
                        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Product.self))
                        fetchRequest.predicate = NSPredicate(format: "productId == %ld", productId)
                        
                        do {
                            let productEntity = try (context.fetch(fetchRequest) as? [Product])?.first
                            if(dictionary["ranking"]?.lowercased == "most viewed products")
                            {
                                productEntity?.productViewCount = productObj["view_count"] as! Int64
                            }
                            else if(dictionary["ranking"]?.lowercased == "most shared products")
                            {
                                productEntity?.productShareCount = productObj["shares"] as! Int64
                            }
                            else if(dictionary["ranking"]?.lowercased == "most ordered products")
                            {
                                productEntity?.productOrderCount = productObj["order_count"] as! Int64
                            }
                            
                        } catch let error {
                                print("ERROR FETCHING PRODUCT: \(error)")
                        }
                    }
                }
            }
            return rankingEntity
        }
        return nil
    }
    
    // MARK: UITableViewDataSource and UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let categoryObject = self.arrCategories[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell
        cell.nameLabel.text = categoryObject.categoryName
        
        if (categoryObject.categoryProductsInfo != nil && categoryObject.categoryProductsInfo!.count > 0)
        {
            cell.accessoryType = .none
        }
        else
        {
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let categoryObject = self.arrCategories[indexPath.row]
        if (categoryObject.categoryProductsInfo != nil && categoryObject.categoryProductsInfo!.count > 0)
        {
            print("Show the Products screen")
            let vc = self.storyboard?.instantiateViewController(identifier: "ProductListingViewController") as! ProductListingViewController
            vc.categoryOfProducts = categoryObject
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            print("Show the sub-categories screen")
            let vc = self.storyboard?.instantiateViewController(identifier: "CategoryListingViewController") as! CategoryListingViewController
            vc.arrCategories = categoryObject.subCategoryInfo?.allObjects as! [Category]
            vc.titleToDisplay = categoryObject.categoryName!
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
