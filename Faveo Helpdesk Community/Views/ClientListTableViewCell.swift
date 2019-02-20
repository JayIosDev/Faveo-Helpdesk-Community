//
//  ClientListTableViewCell.swift
//  Faveo Helpdesk Community
//
//  Created by Mallikarjun on 17/01/19.
//  Copyright © 2019 Ladybird Web Solution. All rights reserved.
//

import UIKit

class ClientListTableViewCell: UITableViewCell {

    @IBOutlet weak var userProfilePicture: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userMobileNumber: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
