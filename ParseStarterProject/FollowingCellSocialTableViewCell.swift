//
//  FollowingCellSocialTableViewCell.swift
//  
//
//  Created by Flavio Lici on 8/2/15.
//
//

import UIKit

class FollowingCellSocialTableViewCell: UITableViewCell {

    @IBOutlet var imageToPost: UIImageView!
    
    @IBOutlet var followingNews: UILabel!
    
    @IBOutlet var timePosted: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
