//
//  ProductListingViewController.swift
//  HeadyEcommerce
//
//  Created by Prem Budhwani on 12/08/20.
//  Copyright © 2020 Heady. All rights reserved.
//

import UIKit

class ProductListingViewController: UIViewController , UITableViewDataSource , ProductTableViewCellDelegate {
    
    @IBOutlet weak var productsTableView: UITableView!
    var categoryOfProducts : Category?
    var arrayOfProductsToShow : [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = self.categoryOfProducts?.categoryName
        self.productsTableView.tableFooterView = UIView()
        
        self.arrayOfProductsToShow = categoryOfProducts?.categoryProductsInfo?.allObjects as! [Product]
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayOfProductsToShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let productObject = self.arrayOfProductsToShow[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as! ProductTableViewCell
        cell.productNameLabel.text = productObject.productName
        cell.productTaxLabel.text = "\(productObject.productTaxInfo?.taxName ?? "") : \(productObject.productTaxInfo?.taxValue ?? 0)%"
        cell.productViewedCount.text = String(describing: productObject.productViewCount)
        cell.productOrderedCount.text = String(describing: productObject.productOrderCount)
        cell.productSharedCount.text = String(describing: productObject.productShareCount)
        
        let arrTemp = productObject.productDateAdded?.components(separatedBy: "T")
        if (arrTemp!.count>1)
        {
            cell.productDateLabel.text = "Date : \(arrTemp?[0] ?? "- -")"
        }
        else
        {
            cell.productDateLabel.text = "Date : \(productObject.productDateAdded ?? "- -")"
        }
        
        cell.indexpath = indexPath
        cell.delegate = self
        return cell
    }
    
    // MARK: ProductTableViewCellDelegate
    func variantsButtonDidTapped(indexpath: IndexPath) {
        let productObject = self.arrayOfProductsToShow[indexpath.row]
        let vc = self.storyboard?.instantiateViewController(identifier: "VariantsListingViewController") as! VariantsListingViewController
        vc.productOfVariants = productObject
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
