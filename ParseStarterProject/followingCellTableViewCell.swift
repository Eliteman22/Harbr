//
//  followingCellTableViewCell.swift
//  
//
//  Created by Flavio Lici on 7/31/15.
//
//

import UIKit

class followingCellTableViewCell: UITableViewCell {

    @IBOutlet var usernameFollowing: UILabel!
    
    @IBOutlet var followingProPic: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
