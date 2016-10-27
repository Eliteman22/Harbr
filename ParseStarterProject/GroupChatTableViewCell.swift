//
//  GroupChatTableViewCell.swift
//  
//
//  Created by Flavio Lici on 7/3/15.
//
//

import UIKit

class GroupChatTableViewCell: UITableViewCell {
    
    @IBOutlet var commentsBlock: UITextView!
    
    @IBOutlet var dateCreated: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        commentsBlock.layer.cornerRadius = 7
        commentsBlock.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
