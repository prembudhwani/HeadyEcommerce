//
//  ProductListingViewController.swift
//  HeadyEcommerce
//
//  Created by Prem Budhwani on 12/08/20.
//  Copyright © 2020 Heady. All rights reserved.
//

import UIKit
import CoreData

class ProductListingViewController: UIViewController , UITableViewDataSource , ProductTableViewCellDelegate ,
UIPickerViewDataSource , UIPickerViewDelegate {
    
    @IBOutlet weak var productsTableView: UITableView!
    var categoryOfProducts : Category?
    var arrayOfProductsToShow : [Product] = []
    
    @IBOutlet weak var filterTextField: UITextField!
    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var orderButton: UIButton!
    var arrayOfFilters : [String] = []
    var selectedFilter : String?
    let pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = self.categoryOfProducts?.categoryName
        self.productsTableView.tableFooterView = UIView()
        orderLabel.isHidden = true
        orderButton.isHidden = true
        self.arrayOfProductsToShow = categoryOfProducts?.categoryProductsInfo?.allObjects as! [Product]
        
        //Initialize array for filters
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Ranking.self))
        do {
            if let objects  = try context.fetch(fetchRequest) as? [Ranking]
            {
                for obj in objects
                {
                    self.arrayOfFilters.append((obj.rankingName?.uppercased())!)
                }
                self.arrayOfFilters.insert("NONE", at: 0)
            }
        } catch let error {
            print("ERROR FETCHING RANKINGS : \(error)")
        }
        
        self.setUpPickerView()
        self.filterTextField.addTarget(self, action: #selector(filterEditingChanged), for: .editingChanged)
    }
    
    @objc func filterEditingChanged()
    {
        self.filterTextField.text = self.selectedFilter
    }
    
    func setUpPickerView()
    {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.pickerViewDoneButtonTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton , doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.filterTextField.inputAccessoryView = toolBar
        self.filterTextField.inputView = pickerView
        self.pickerView.delegate = self
    }
    
    @objc func pickerViewDoneButtonTapped() {
        self.view.endEditing(true)
        self.applyFilter()
    }
    
    @IBAction func orderButtonTapped(_ sender: Any) {
        self.orderButton.isSelected = !self.orderButton.isSelected
        self.applyFilter()
    }
    
    func applyFilter()
    {
        switch self.selectedFilter {
        case "NONE":
            self.arrayOfProductsToShow = categoryOfProducts?.categoryProductsInfo?.allObjects as! [Product]
            
        case "MOST VIEWED PRODUCTS":
            let allProducts = categoryOfProducts?.categoryProductsInfo?.allObjects as! [Product]
            self.arrayOfProductsToShow = allProducts.filter { (productObj : Product) -> Bool in
                return (productObj.productViewCount > 0)
            }
            self.arrayOfProductsToShow.sort { (obj1 : Product, obj2 : Product) -> Bool in
                if(self.orderButton.isSelected)
                {
                    return (obj1.productViewCount > obj2.productViewCount)          //Sort Descending
                }
                else
                {
                    return (obj1.productViewCount < obj2.productViewCount)          //Sort Ascending
                }
            }
            
        case "MOST ORDERED PRODUCTS":
            let allProducts = categoryOfProducts?.categoryProductsInfo?.allObjects as! [Product]
            self.arrayOfProductsToShow = allProducts.filter { (productObj : Product) -> Bool in
                return (productObj.productOrderCount > 0)
            }
            self.arrayOfProductsToShow.sort { (obj1 : Product, obj2 : Product) -> Bool in
                if(self.orderButton.isSelected)
                {
                    return (obj1.productOrderCount > obj2.productOrderCount)        //Sort Descending
                }
                else
                {
                    return (obj1.productOrderCount < obj2.productOrderCount)        //Sort Ascending
                }
            }
            
        case "MOST SHARED PRODUCTS":
            let allProducts = categoryOfProducts?.categoryProductsInfo?.allObjects as! [Product]
            self.arrayOfProductsToShow = allProducts.filter { (productObj : Product) -> Bool in
                return (productObj.productShareCount > 0)
            }
            self.arrayOfProductsToShow.sort { (obj1 : Product, obj2 : Product) -> Bool in
                if(self.orderButton.isSelected)
                {
                    return (obj1.productShareCount > obj2.productShareCount)        //Sort Descending
                }
                else
                {
                    return (obj1.productShareCount < obj2.productShareCount)        //Sort Ascending
                }
            }
            
        default:
            print("....")
        }
        
        self.productsTableView.reloadData()
        self.productsTableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
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
    
    // MARK: UIPickerViewDataSource and UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.arrayOfFilters.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.arrayOfFilters[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedFilter = self.arrayOfFilters[row]
        self.filterTextField.text = self.selectedFilter
        
        //Show or hide the Ascending/Descending order button
        if(self.filterTextField.text == "NONE")
        {
            self.orderLabel.isHidden = true
            self.orderButton.isHidden = true
        }
        else
        {
            self.orderLabel.isHidden = false
            self.orderButton.isHidden = false
            self.orderButton.isSelected = false     //By default show "Unselected" state i.e. "ASCENDING" order
        }
    }
}
