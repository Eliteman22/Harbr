//
//  MyPicturesTableViewCell.swift
//  Harbr
//
//  Created by Flavio Lici on 9/22/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit

class MyPicturesTableViewCell: UITableViewCell {
    
    @IBOutlet var imagePosted: UIImageView!
    
    @IBOutlet var eventType: UIImageView!
    
    @IBOutlet var points: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
