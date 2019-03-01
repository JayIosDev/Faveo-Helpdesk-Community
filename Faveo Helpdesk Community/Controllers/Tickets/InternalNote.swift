//
//  InternalNote.swift
//  Faveo Helpdesk Community
//
//  Created by Mallikarjun on 24/01/19.
//  Copyright © 2019 Ladybird Web Solution. All rights reserved.
//

import UIKit
import RMessage


class InternalNote: UITableViewController,RMControllerDelegate,UITextViewDelegate {

    
    @IBOutlet var tableViewOutlet: UITableView!

    @IBOutlet weak var messageTextView: UITextView!
    
    //RMessage
    private let rControl = RMController()
    
    let userDefaults = UserDefaults.standard

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // to set black background color mask for Progress view
        
        
        self.tableViewOutlet.tableFooterView = UIView()
        
        //RMessage
        rControl.presentationViewController = self
        rControl.delegate = self
        
    }
    
    
    @IBAction func addNoteButtonClicked(_ sender: Any) {
        
        print("Clicked on internal note button")
        
        
        if messageTextView.text == ""{
            
            showAlert(title: "Faveo Helpdesk", message: "Enter the note content", vc: self)
        }
        else if (messageTextView!.text?.count)! < 2 {
            
            showAlert(title: "Faveo Helpdesk", message: "Note content should be more than 1 characters", vc: self)
        }
        else
        {
            addInternalNoteAPICall()
        }
        
    }
    
    
    func addInternalNoteAPICall(){
        
        
        var url:String = UserDefaults.standard.string(forKey: "baseURL") ?? ""
        url.append("api/v1/helpdesk/internal-note")
        
        let tokenValue = userDefaults.string(forKey:"token")
        let userId = userDefaults.string(forKey:"userId")
        
        let noteData = messageTextView.text
        let ticketId = GlobalVariables.sharedManager.ticketId
        
        requestPOSTURL(url, params: ["token":tokenValue as AnyObject,
                                     "body":noteData as AnyObject,
                                     "ticket_id":ticketId as AnyObject,
                                     "user_id":userId as AnyObject,
                                     ], success: { (data) in
                                        
                                        
                                        print("JSON is: ",data)
                                        
                                        let msg = data["message"].stringValue
                                        print("Message is: ",msg)
                                        
                                        if msg == "Token has expired"{
                                            
                                            tokenRefreshMethod()
                                            self.addInternalNoteAPICall()
                                        }
                                        else{
                                            
                                            
                                            if data["thread"].exists(){
                                                //data is there
                                                
                                                print("I am in print - Added Internal Note")
                                                
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
                                                    body: " Added Note successfully..!",
                                                    viewController: navigationController
                                                )
                                                
                                                NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)
                                                
                                                ////Showing Success Message End
                                                navigationController.popViewController(animated: true)
                                                
                                            }
                                            else if data["error"]["body"].exists(){
                                                
                                                showAlert(title: "Alert", message: "Note content is required. It should not be empty.", vc: self)
                                                
                                            }
                                            else{
                                                
                                                showAlert(title: "Error", message: "Something went wrong. Please try again later.", vc: self)
                                                
                                            }
 
                                            
                                        }
                                        
        }) { (error) in
            
            //Example: After timeout error - The request timed out.
            print("Error From Add Internal Note Method: \(error.localizedDescription)")
            
            showAlert(title: "Faveo Heldesk", message: error.localizedDescription, vc: self)
        }
        
        
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
    
}

