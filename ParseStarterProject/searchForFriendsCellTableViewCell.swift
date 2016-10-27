//
//  searchForFriendsCellTableViewCell.swift
//  
//
//  Created by Flavio Lici on 8/5/15.
//
//

import UIKit

class searchForFriendsCellTableViewCell: UITableViewCell {
    
    @IBOutlet var imageToPost: UIImageView!
    
    @IBOutlet var friendsName: UILabel!
    
    @IBOutlet var isAFollower: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
