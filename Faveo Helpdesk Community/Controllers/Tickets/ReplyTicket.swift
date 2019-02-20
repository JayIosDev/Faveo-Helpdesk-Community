//
//  ReplyTicket.swift
//  Faveo Helpdesk Community
//
//  Created by Mallikarjun on 24/01/19.
//  Copyright © 2019 Ladybird Web Solution. All rights reserved.
//

import UIKit
import SVProgressHUD
import RMessage

class ReplyTicket: UITableViewController,RMControllerDelegate,UITextViewDelegate {

    
    @IBOutlet var tableViewOutlet: UITableView!
    
    @IBOutlet weak var messageTextView: UITextView!
    
    //RMessage
    private let rControl = RMController()
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        // to set black background color mask for Progress view
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.dismiss()
        
        //RMessage
        rControl.presentationViewController = self
        rControl.delegate = self
        
        

    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if textView == messageTextView {
            
            if (text == " ") {
                if textView.text.count == 0 {
                    return false
                }
            }
            
            if (textView.text as NSString).replacingCharacters(in: range, with: text).count < textView.text.count {
                
                return true
            }
            
            if (textView.text as NSString).replacingCharacters(in: range, with: text).count > 200 {
                return false
            }
            
            let set = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890 .*@#$%(),<>;:[]{}=+")
            
            
            if Int((text as NSString).rangeOfCharacter(from: set).location) == NSNotFound {
                return false
            }
        }
        
        
        return true
    }
    

    @IBAction func submitButtonClicked(_ sender: Any) {
        
        print("Clicked on reply button")
        
        SVProgressHUD.show(withStatus: "Please wait...")
        
        if messageTextView.text == ""{
            
            showAlert(title: "Faveo Helpdesk", message: "Enter the reply content", vc: self)
            SVProgressHUD.dismiss()
        }
        else if (messageTextView!.text?.count)! < 2 {
        
            showAlert(title: "Faveo Helpdesk", message: "Reply content should be more than 1 characters", vc: self)
            SVProgressHUD.dismiss()
        }
        else
        {
            replyTicketAPICall()
        }
        
    }
    
    func replyTicketAPICall(){
        
       
        var url:String = UserDefaults.standard.string(forKey: "baseURL") ?? ""
        url.append("api/v1/helpdesk/reply")
        
        let tokenValue = userDefaults.string(forKey:"token")
        
        let replyData = messageTextView.text
        let ticketId = GlobalVariables.sharedManager.ticketId
        
        requestPOSTURL(url, params: ["token":tokenValue as AnyObject,
                                     "reply_content":replyData as AnyObject,
                                     "ticket_id":ticketId as AnyObject,
                                      ], success: { (data) in
                                        
                                        
                                        print("JSON is: ",data)
                                        
                                        let msg = data["message"].stringValue
                                        print("Message is: ",msg)
                                        
                                        if msg == "Token has expired"{
                                            
                                            tokenRefreshMethod()
                                            self.replyTicketAPICall()
                                        }
                                        else{
                                            
                                            
                                            if data["result"].exists(){
                                                //data is there
                                                
                                              print("I am in print - Replied successfully")
                                              
                                                guard let navigationController = self.navigationController else {
                                                    return
                                                }
                                                
                                                if navigationController.isNavigationBarHidden {
                                                    navigationController.isNavigationBarHidden = false
                                                }
                                                
                                                //Showing Success Message
                                                var iconSpec = successSpec
                                                iconSpec.iconImage = UIImage(named: "SuccessMessageIcon")
                                                
                                                self.rControl.showMessage(
                                                    withSpec: iconSpec,
                                                    atPosition: .navBarOverlay, // .top // .bottom
                                                    title: "Done",
                                                    body: " Replied successfully..!",
                                                    viewController: navigationController
                                                )
                                               
                                                NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)
                                                self.view.setNeedsDisplay()
                                                ////Showing Success Message End
                                               // SVProgressHUD.dismiss()
                                                navigationController.popViewController(animated: true)
                                                
                                            }
                                            else if data["error"]["reply_content"].exists(){
                                                
                                                showAlert(title: "Alert", message: "Reply content is required. It should not be empty.", vc: self)
                                                SVProgressHUD.dismiss()
                                                
                                            }
                                            else{
                                                
                                                showAlert(title: "Error", message: "Something went wrong. Please try again later.", vc: self)
                                                SVProgressHUD.dismiss()
                                                
                                            }
                                            
                                     
                                        }
                                        
        }) { (error) in
            
            //Example: After timeout error - The request timed out.
            print("Error From Reply Ticket Method: \(error.localizedDescription)")
            
            showAlert(title: "Faveo Heldesk", message: error.localizedDescription, vc: self)
            SVProgressHUD.dismiss()
        }
        
        
    }
    
        
    

}
