//
//  TicketTableViewCell.swift
//  Faveo Helpdesk Community
//
//  Created by Mallikarjun on 06/01/19.
//  Copyright © 2019 Ladybird Web Solution. All rights reserved.
//

import UIKit
import SwiftHEXColors
class TicketTableViewCell: UITableViewCell {

    
    @IBOutlet weak var userProfilePicture: UIImageView!
    @IBOutlet weak var indicationView: UIView!
    @IBOutlet weak var ticketNumber: UILabel!
    @IBOutlet weak var ticketSubject: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var dueToday: UILabel!
    @IBOutlet weak var overDue: UILabel!
    
    @IBOutlet weak var ticketOwnerName: UILabel!
    
      @IBOutlet weak var BackView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        BackView.layer.cornerRadius = 5.0
        BackView.layer.shadowColor = UIColor.gray.cgColor
        BackView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        BackView.layer.shadowRadius = 12.0
        BackView.layer.shadowOpacity = 0.4

//        BackView.layer.cornerRadius = 10
//        BackView.layer.masksToBounds = true
//        BackView.layer.shadowRadius = 5
//        BackView.layer.shadowColor = UIColor.black.cgColor
//        BackView.layer.shadowOpacity = 0.5
//        BackView.layer.shadowOffset = CGSize(width:0, height:1)
//        BackView.layer.shadowOffset
      
        //Adding curves to indiaction view (priority)
        let maskPath = UIBezierPath(roundedRect: indicationView.bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: 10.0, height: 10.0))
        
        let maskLayer = CAShapeLayer()

        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath

        indicationView.layer.mask = maskLayer

        
        //making userProfileImage Circular
        userProfilePicture.layer.cornerRadius = 25
        userProfilePicture.clipsToBounds = true

    }

  

    func setUserProfileimage(imageUrl:URL) {
    
        let data = try? Data(contentsOf: imageUrl)
        
        if let imageData = data {
            let image = UIImage(data: imageData)
            userProfilePicture.image = image
        }
        
    }
    
    func setPriorityColor(color:String) {
        
        self.indicationView.backgroundColor = UIColor(hexString: color)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
  
}
