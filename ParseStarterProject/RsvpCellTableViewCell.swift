//
//  RsvpCellTableViewCell.swift
//  
//
//  Created by Flavio Lici on 7/5/15.
//
//

import UIKit

class RsvpCellTableViewCell: UITableViewCell {

    @IBOutlet var username: UILabel!
    
    @IBOutlet var imageToPost: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
