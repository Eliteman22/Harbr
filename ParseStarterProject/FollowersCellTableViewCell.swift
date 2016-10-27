//
//  FollowersCellTableViewCell.swift
//  
//
//  Created by Flavio Lici on 7/31/15.
//
//

import UIKit

class FollowersCellTableViewCell: UITableViewCell {
    
    @IBOutlet var followerUsername: UILabel!
    
    @IBOutlet var followerProPic: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
