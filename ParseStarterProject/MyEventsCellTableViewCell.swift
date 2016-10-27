//
//  MyEventsCellTableViewCell.swift
//  
//
//  Created by Flavio Lici on 7/4/15.
//
//

import UIKit
import Parse

class MyEventsCellTableViewCell: UITableViewCell {
    
    @IBOutlet var eventName: UILabel!
    
    @IBOutlet var numberOfPeopleAttending: UILabel!
    
    @IBOutlet var address: UILabel!
    
    @IBOutlet var date: UILabel!
    
    @IBOutlet var time: UILabel!
    
    @IBOutlet var venueName: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        eventName.text = ""
        numberOfPeopleAttending.text = ""
        address.text = ""
        date.text = ""
        time.text = ""
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
