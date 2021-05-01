//
//  StopTableCellTableViewCell.swift
//  rossk_train_tracker
//
//  Created by Kim Ross on 5/1/21.
//

import UIKit

class StopTableCell: UITableViewCell {

    @IBOutlet var lblStopName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
