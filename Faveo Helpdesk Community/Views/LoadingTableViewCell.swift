//
//  LoadingTableViewCell.swift
//  Faveo Helpdesk Community
//
//  Created by Mallikarjun on 22/01/19.
//  Copyright © 2019 Ladybird Web Solution. All rights reserved.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {

    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var loadingLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
