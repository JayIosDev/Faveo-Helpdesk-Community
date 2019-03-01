//
//  ConversationTableViewCell.swift
//  Faveo Helpdesk Community
//
//  Created by Mallikarjun on 19/01/19.
//  Copyright © 2019 Ladybird Web Solution. All rights reserved.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var internalNoteLabel: UILabel!

    @IBOutlet weak var view1: UIView!
    
    @IBOutlet weak var webView: UIWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backView.layer.cornerRadius = 5.0
        backView.layer.shadowColor = UIColor.gray.cgColor
        backView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        backView.layer.shadowRadius = 12.0
        backView.layer.shadowOpacity = 0.4
        
        //making userProfileImage Circular
        profilePicture.layer.cornerRadius = 25
        profilePicture.clipsToBounds = true
        
    }
    
    func setUserProfileimage(imageUrl:URL) {
        
        let data = try? Data(contentsOf: imageUrl)
        
        if let imageData = data {
            let image = UIImage(data: imageData)
            profilePicture.image = image
        }
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
