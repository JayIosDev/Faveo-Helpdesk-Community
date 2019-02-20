//
//  AboutUsViewController.swift
//  Faveo Helpdesk Community
//
//  Created by Mallikarjun on 16/01/19.
//  Copyright © 2019 Ladybird Web Solution. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {

    
    @IBOutlet weak var textViewData: UITextView!
    
    @IBOutlet weak var webisiteButtonOutlet: UIButton!
    
    
    @IBOutlet weak var menuButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        textViewData.isEditable = false
        
        // Do any additional setup after loading the view.
         setUpSideMenuBar()
    }
    
    //setting up side-menu bar
    func setUpSideMenuBar(){
        
        if revealViewController() != nil{
            
            menuButtonItem.target = revealViewController()
            menuButtonItem.action = #selector(SWRevealViewController.revealToggle(_:))
            
            revealViewController()?.rearViewRevealWidth = 320 //320
            // revealViewController()?.rightViewRevealWidth = 160
            
            view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        }
        
    }// End of setUpSideMenuBar method
    
    
    //
    @IBAction func websiteButtonClicked(_ sender: Any) {
       
        if let url = URL(string: "https://www.faveohelpdesk.com/"), !url.absoluteString.isEmpty {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    

}
