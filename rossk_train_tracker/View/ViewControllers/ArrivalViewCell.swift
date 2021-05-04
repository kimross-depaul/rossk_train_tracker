//
//  ArrivalViewCell.swift
//  rossk_train_tracker
//
//  Created by Kim Ross on 5/2/21.
//

import UIKit

class ArrivalViewCell: UITableViewCell {

    @IBOutlet var lblDetails: UILabel!
    @IBOutlet var lblMain: UILabel!
    @IBOutlet var lblMinutes: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
