//
//  CommentCellTableViewCell.swift
//  
//
//  Created by Flavio Lici on 7/2/15.
//
//

import UIKit

class CommentCellTableViewCell: UITableViewCell {
    
    @IBOutlet var CommentBlock: UITextView!
    
    
    @IBOutlet var dateCreated: UILabel!
    
    @IBOutlet var usernamePosted: UILabel!
    
    @IBOutlet var imageInFeed: UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        CommentBlock.layer.cornerRadius = 10
        CommentBlock.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
