//
//  DetailsTableViewCell.swift
//  InAppPurchase_test10
//
//  Created by 侯懿玲 on 2023/2/10.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {

    static let identifier = "DetailsTableViewCell"
    
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUI(title: String, startTime: String, endTime: String) {
        detailLabel.text = title
        startTimeLabel.text = startTime
        endTimeLabel.text = endTime
    }
    
}
