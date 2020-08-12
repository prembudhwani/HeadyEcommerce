//
//  ProductTableViewCell.swift
//  HeadyEcommerce
//
//  Created by Prem Budhwani on 12/08/20.
//  Copyright © 2020 Heady. All rights reserved.
//

import UIKit

protocol ProductTableViewCellDelegate {
    func variantsButtonDidTapped(indexpath:IndexPath)
}

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productTaxLabel: UILabel!
    @IBOutlet weak var productDateLabel: UILabel!
    @IBOutlet weak var productViewedCount: UILabel!
    @IBOutlet weak var productOrderedCount: UILabel!
    @IBOutlet weak var productSharedCount: UILabel!
    @IBOutlet weak var variantsButton: UIButton!
    
    var delegate : ProductTableViewCellDelegate?
    var indexpath : IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func variantsButtonTapped(_ sender: Any) {
        if let del = self.delegate
        {
            del.variantsButtonDidTapped(indexpath: self.indexpath!)
        }
    }
}
