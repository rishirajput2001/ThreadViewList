//
//  ViewMoreCell.swift
//  ListDemo
//
//  Created by Pushpendra Rajput  on 24/04/25.
//

import UIKit

class ViewMoreCell: UITableViewCell {

    @IBOutlet weak var lblFirstname: UILabel!
    
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
