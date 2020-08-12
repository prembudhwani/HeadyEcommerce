//
//  VariantsListingViewController.swift
//  HeadyEcommerce
//
//  Created by Prem Budhwani on 12/08/20.
//  Copyright © 2020 Heady. All rights reserved.
//

import UIKit

class VariantsListingViewController: UIViewController , UITableViewDataSource{
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var variantsTableView: UITableView!
    
    var productOfVariants : Product?
    var arrayOfVariantsToShow : [Variant] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Variants Info"
        self.productNameLabel.text = productOfVariants?.productName
        self.variantsTableView.tableFooterView = UIView()
        
        self.arrayOfVariantsToShow = productOfVariants?.productVariantInfo?.allObjects as! [Variant]
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
        return self.arrayOfVariantsToShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let variantObject = self.arrayOfVariantsToShow[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "VariantTableViewCell", for: indexPath) as! VariantTableViewCell
        cell.idLabel.text = "ID : \(variantObject.variantId)"
        cell.colorLabel.text = "Color : \(variantObject.variantColor ?? "")"
        cell.sizeLabel.text = "Size : \(variantObject.variantSize ?? "")"
        cell.priceLabel.text = "Price : Rs. \(variantObject.variantPrice)"
        return cell
    }
}
