//
//  IAPurchaseItemsTableViewCell.swift
//  InAppPurchase_test10
//
//  Created by 侯懿玲 on 2023/1/17.
//

import UIKit
import StoreKit

class IAPurchaseItemsTableViewCell: UITableViewCell {
    
    static let identifier = "IAPurchaseItemsTableViewCell"
    private var selectedProductIndex = 0
    var delegateToBuy: ToBuy!
    
    @IBOutlet weak var consumableTitleLabel: UILabel!
    @IBOutlet weak var addItemsButton: UIButton!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setInit(title: String, buttonTitle: String, index: Int){
        consumableTitleLabel.text = title
        addItemsButton.setTitle(buttonTitle, for: .normal)
        selectedProductIndex = index
    }
    
    @IBAction func toBuy(_ sender: UIButton) {
        delegateToBuy.toBuy(index: selectedProductIndex)
    }
}

protocol ToBuy {
    func toBuy(index: Int)
}
