//
//  TicketDetailsViewController.swift
//  Faveo Helpdesk Community
//
//  Created by Mallikarjun on 10/01/19.
//  Copyright © 2019 Ladybird Web Solution. All rights reserved.
//

import UIKit
import JJFloatingActionButton
import SVProgressHUD

class TicketDetailsViewController: UIViewController {

    
    @IBOutlet weak var ticketNumber: UILabel!
    @IBOutlet weak var clientName: UILabel!
    @IBOutlet weak var ticketStatus: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    var currentViewController:UIViewController!
    
    //Segmented control
    @IBOutlet weak var segmentedControlOutlet: UISegmentedControl!
    
    //floating point button
    fileprivate let actionButton = JJFloatingActionButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "Details"

        
        // to set black background color mask for Progress view
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.dismiss()
        
        let editImage    = UIImage(named: "pencileEdit")!
        let editTicketButton   = UIBarButtonItem(image: editImage,  style: .plain, target: self, action: #selector(self.editTicketButtonClicked) )
        
        navigationItem.rightBarButtonItems = [editTicketButton]
    
        
        self.currentViewController = self.storyboard?.instantiateViewController(withIdentifier: "ConversationViewControllerID") as! ConversationViewController
        self.currentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.addChild(self.currentViewController)
        self.addSubview(subView: self.currentViewController.view, parentView: self.containerView)
        
        
        //set up floating point button
        self.setUpFloatingPointButton()
        
        
    }
    
    
    func setUpFloatingPointButton() {
        
        //Floating Point Button
        let actionButton = JJFloatingActionButton()
            
        actionButton.addItem(title: "Internal Note", image: UIImage(named: "note3")?.withRenderingMode(.alwaysTemplate)) { item in
            
            item.buttonImageColor = UIColor(hexString: "#0080FF")!
            // do something
            print("Clicked on Internal Notes")
            
            let internalNoteView = self.storyboard?.instantiateViewController(withIdentifier: "InternalNote") as! InternalNote
            
            self.navigationController?.pushViewController(internalNoteView, animated: true)
            
        }
        
        actionButton.addItem(title: "Ticket Reply", image: UIImage(named: "reply1")?.withRenderingMode(.alwaysTemplate)) { item in
            
            item.buttonImageColor = UIColor(hexString: "#0080FF")!
            // do something
            print("Clicked on Ticket Reply")
            
            let replyTicketView = self.storyboard?.instantiateViewController(withIdentifier: "ReplyTicketID") as! ReplyTicket
            
            self.navigationController?.pushViewController(replyTicketView, animated: true)
            
        }
        
        
        actionButton.display(inViewController: self)
        
        //actionButton.buttonColor = .blue //this is color of main button
        actionButton.buttonColor = UIColor(hexString: "#0080FF")!
        //actionButton.buttonImageColor = .purple //this is color of image in main button
        actionButton.overlayView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        
    
        //        actionButton.layer.shadowColor = UIColor.black.cgColor
        //        actionButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        //        actionButton.layer.shadowOpacity = Float(0.4)
        //        actionButton.layer.shadowRadius = CGFloat(2)
        
        
    }
    
    
    @objc func editTicketButtonClicked(){
        
     //  print("edit clicked")
        
        let editTicketDetailsView = self.storyboard?.instantiateViewController(withIdentifier: "EditTicketDetailsID") as! EditTicketDetails
        
        self.navigationController?.pushViewController(editTicketDetailsView, animated: true)
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        ticketNumber.text = GlobalVariables.sharedManager.ticketNumber
        clientName.text = GlobalVariables.sharedManager.firstName
        ticketStatus.text = GlobalVariables.sharedManager.ticketStatus
    }

    //func power(base: Int, exponent: Int)
    func addSubview(subView: UIView, parentView: UIView){
        
        parentView.addSubview(subView)
        
        // Create a new (key: string, value: string) dictionary
        var viewsDict: Dictionary = [String: String]()
        viewsDict["subView"] = "subView"
        
        var constraint = NSLayoutConstraint(item: subView,
                                            attribute: NSLayoutConstraint.Attribute.top,
                                            relatedBy: NSLayoutConstraint.Relation.equal,
                                            toItem: self.containerView,
                                            attribute: NSLayoutConstraint.Attribute.top,
                                            multiplier: 1,
                                            constant: 0)
        
        self.view.addConstraint(constraint)
        
        
        constraint = NSLayoutConstraint(item: subView,
                                        attribute: NSLayoutConstraint.Attribute.height,
                                        relatedBy: NSLayoutConstraint.Relation.equal,
                                        toItem: self.containerView,
                                        attribute: NSLayoutConstraint.Attribute.height,
                                        multiplier: 1,
                                        constant: 0)
        
        self.view.addConstraint(constraint)
        
        constraint = NSLayoutConstraint(item: subView,
                                        attribute: NSLayoutConstraint.Attribute.leading,
                                        relatedBy: NSLayoutConstraint.Relation.equal,
                                        toItem: self.containerView,
                                        attribute: NSLayoutConstraint.Attribute.leading,
                                        multiplier: 1,
                                        constant: 0)
        
        self.view.addConstraint(constraint)
        
        
        constraint = NSLayoutConstraint(item: subView,
                                        attribute: NSLayoutConstraint.Attribute.trailing,
                                        relatedBy: NSLayoutConstraint.Relation.equal,
                                        toItem: self.containerView,
                                        attribute: NSLayoutConstraint.Attribute.trailing,
                                        multiplier: 1,
                                        constant: 0)
        
        self.view.addConstraint(constraint)
        
        
    }
    
    @IBAction func segmentedControlAction(_ sender: Any) {
        
        if segmentedControlOutlet.selectedSegmentIndex==0{
            
            let newViewController:UIViewController = self.storyboard?.instantiateViewController(withIdentifier: "ConversationViewControllerID") as! ConversationViewController
            
            newViewController.view.translatesAutoresizingMaskIntoConstraints = false
            
            self.cycleFromViewController(oldViewController: self.currentViewController, newViewController: newViewController)
            self.currentViewController = newViewController
            
        }
        else{
            
            let newViewController:UIViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewControllerID") as! DetailsViewController
            
            newViewController.view.translatesAutoresizingMaskIntoConstraints = false
            
            self.cycleFromViewController(oldViewController: self.currentViewController, newViewController: newViewController)
            
            self.currentViewController = newViewController
            
        }
        
        
    }
    
    func cycleFromViewController(oldViewController: UIViewController, newViewController:UIViewController) {
        
        oldViewController.willMove(toParent: nil)
        
        self.addChild(newViewController)
        self.addSubview(subView: newViewController.view, parentView: self.containerView)
        //newViewController.view.alpha = 0
        
        newViewController.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5, animations: {
            
            //   newViewController.view.alpha = 0
            //   oldViewController.view.alpha = 0
            
        }) { (BOOL) in
            
            oldViewController.view.removeFromSuperview()
            oldViewController.removeFromParent()
            newViewController.didMove(toParent: self)
        }
        
    }

}
