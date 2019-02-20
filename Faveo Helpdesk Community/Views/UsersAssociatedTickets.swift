//
//  UsersAssociatedTickets.swift
//  Faveo Helpdesk Community
//
//  Created by Mallikarjun on 19/01/19.
//  Copyright © 2019 Ladybird Web Solution. All rights reserved.
//

import UIKit


class UsersAssociatedTickets: UITableViewCell {

    
    @IBOutlet weak var indicationView: UIView!
    
    
    @IBOutlet weak var ticketNumber: UILabel!
    
    
    @IBOutlet weak var ticketSubject: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //Adding curves to indiaction view (priority)
   /*     let maskPath = UIBezierPath(roundedRect: indicationView.bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: 10.0, height: 10.0))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        
        indicationView.layer.mask = maskLayer */
        
    }
 
    func setPriorityColor(color:String) {
        
        self.indicationView.backgroundColor = UIColor(hexString: color)
    }
 
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
