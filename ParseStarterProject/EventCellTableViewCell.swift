//
//  EventCellTableViewCell.swift
//  
//
//  Created by Flavio Lici on 6/30/15.
//
//

import UIKit


class EventCellTableViewCell: UITableViewCell {
    
    @IBOutlet var eventName: UILabel!
    
    @IBOutlet var imageToPost: UIImageView!
    
    @IBOutlet var eventTIme: UILabel!
    
    
    @IBOutlet var eventDescription: UILabel!
    
    
    @IBOutlet var numberOfVotes: UILabel!
    
    @IBOutlet var eventType: UILabel!
    
    @IBOutlet var venueName: UILabel!
    
    @IBOutlet var venueId: UILabel!
    
    @IBOutlet var rsvpEdit: UIButton!
    @IBOutlet var eventDate: UILabel!
    
    @IBOutlet var nightShade: UIImageView!
    
    @IBOutlet var waypoint: UIImageView!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        

        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func didScroll(tableView: UITableView, superView: UIView)
    {
        var rectInSuperView: CGRect = tableView.convertRect(self.frame, toView: superView);
        var distanceFromCenter = CGRectGetHeight(superView.frame)/2 - CGRectGetMinY(rectInSuperView);
        var difference = CGRectGetHeight(self.imageToPost.frame) - CGRectGetHeight(self.frame);
        var move = (distanceFromCenter / CGRectGetHeight(superView.frame)) * difference;
        
        var imageRect = self.imageToPost.frame;
        imageRect.origin.y = -(difference / 2) + move;
        self.imageToPost.frame = imageRect;
    }

}
