//
//  SocialCellTableViewCell.swift
//  
//
//  Created by Flavio Lici on 7/1/15.
//
//

import UIKit

class SocialCellTableViewCell: UITableViewCell {
    
    @IBOutlet var eventName: UILabel!
    
    @IBOutlet var imageToPost: UIImageView!
    
    
    @IBOutlet var comment: UILabel!
    
    @IBOutlet var dateCreated: UILabel!
    
    @IBOutlet var username: UIButton!
   
    @IBOutlet var objectIdOfImage: UILabel!
    
    @IBOutlet var userImage: UIImageView!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImage.contentMode = UIViewContentMode.ScaleAspectFill
        userImage.layer.cornerRadius = userImage.frame.height / 2
        userImage.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
