//
//  EditTicketDetails.swift
//  Faveo Helpdesk Community
//
//  Created by Mallikarjun on 11/01/19.
//  Copyright © 2019 Ladybird Web Solution. All rights reserved.


import UIKit
import ActionSheetPicker_3_0
import SVProgressHUD
import RMessage

class EditTicketDetails: UITableViewController,UITextFieldDelegate,RMControllerDelegate,UITextViewDelegate {

    
    @IBOutlet var sampleTableView: UITableView!
    
    @IBOutlet weak var priorityTextField: UITextField!
    @IBOutlet weak var helpTopicTextField: UITextField!
    @IBOutlet weak var sourceTextField: UITextField!
    @IBOutlet weak var slaTextField: UITextField!
    
    
    @IBOutlet weak var subjectTextView: UITextView!
    
    var selectedPriorityId:Int?
    var selectedHelpTopicId:Int?
    var selectedTicketSourceId:Int?
    var selectedSLAId:Int?
    var selectedTicketStatusId:Int?
    
    let userDefaults = UserDefaults.standard
    
    let globalVariable = GlobalVariables.sharedManager
    
    //RMessage
    private let rControl = RMController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Edit Details"
        // to set black background color mask for Progress view
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
        
        
         //RMessage
         rControl.presentationViewController = self
         rControl.delegate = self
        
         self.priorityTextField.delegate = self
         self.helpTopicTextField.delegate = self
         self.sourceTextField.delegate = self
         self.slaTextField.delegate = self
        
         self.tableView.tableFooterView = UIView()
        
        //Get tickets details API call
         getTicketDetails()
        
    }
    
    
    func getTicketDetails() {
        
        
        var ticketThreadURL = userDefaults.string(forKey: "baseURL")
        ticketThreadURL?.append("api/v1/helpdesk/ticket")
        
        let defaults = UserDefaults.standard
        let value = defaults.string(forKey:"token")
        print("token=>",value!)
        
        let tickeId = GlobalVariables.sharedManager.ticketId
        
        requestGETURL(ticketThreadURL!, params: ["token":value as AnyObject,
                                                 "ticket_id":tickeId as AnyObject],  success: { (data) in
                                                    
                                                    
                                                    
                                                 //   print("JSON is: ",data)
                                                    
                                                    let msg = data["message"].stringValue
                                                    print("Message is: ",msg)
                                                    
                                                    if msg == "Token has expired"{
                                                        
                                                        tokenRefreshMethod()
                                                        self.getTicketDetails()
                                                    }
                                                    else{
                                                        
                                                        //do next operations
                                                        
                                                        //ticket title
                                                        let ticketTitle = data["result"]["title"].stringValue
                                                        
                                                        if ticketTitle.isEmpty{
                                                            //ticket title is empty
                                                            self.subjectTextView.text = "Not Available"
                                                        }else{
                                                            //ticket title is not empty
                                                            
                                                            self.subjectTextView.text = ticketTitle
                                                        }
                                                        
                                                        
                                                        //ticket Priority
                                                        let ticketPriority = data["result"]["priority_name"].stringValue
                                                        
                                                        if ticketPriority.isEmpty{
                                                            //priority is empty
                                                            self.priorityTextField.text = "Not Available"
                                                        }else{
                                                            //priority is not empty
                                                            
                                                            self.priorityTextField.text = ticketPriority
                                                        }
                                                        
                                                        //Help Topics
                                                        let helpTopicName = data["result"]["helptopic_name"].stringValue
                                                        
                                                        if helpTopicName.isEmpty{
                                                            //helptopic is empty
                                                            self.helpTopicTextField.text = "Not Available"
                                                        }else{
                                                            //helptopic is not empty
                                                            
                                                            self.helpTopicTextField.text = helpTopicName
                                                        }
                                                        
                                                        
                                                        
                                                        //ticket source
                                                        let ticketSource = data["result"]["source_name"].stringValue
                                                        
                                                        if ticketSource.isEmpty {
                                                            //source is empty
                                                            self.sourceTextField.text = "Not Available"
                                                        }else{
                                                             //source is not empty
                                                            self.sourceTextField.text = ticketSource
                                                        }
                                                        
                                                        
        
                                                        //SLA
                                                        
                                                        let slaName = data["result"]["sla_name"].stringValue
                                                        
                                                        if slaName.isEmpty {
                                                            //   print("Due date is  empty")
                                                            
                                                            self.slaTextField.text = "Not Available"
                                                        }else{
                                                            //   print("Due date is not empty")
                                                            self.slaTextField.text = slaName
                                                            
                                                        }
                                                    
                                                        //ticket status
                                                        
                                                        let statusId = data["result"]["status"].intValue
                                                        
                                                        self.selectedTicketStatusId = statusId
                                                    
                                                        
                                                        
                                                    } // End else of ....if msg == "Token expired"
                                                    
                                                    SVProgressHUD.dismiss()
                                                    
        }) { (error) in
            
            print(error)
            showAlert(title: "Error", message:error.localizedDescription , vc: self)
        }
        
    }
    
    
    
    @IBAction func priorityTextFieldClicked(_ sender: Any) {
       
        ActionSheetStringPicker.show(withTitle: "Select Priority", rows: GlobalVariables.sharedManager.priorityNamesArray, initialSelection: 1, doneBlock: {
            picker, value, index in
            
          //  print("Values is : \(value)")
          //  print("index is : \(index ?? "")")
            
            print("Selected Priority is : \(index ?? "No Value")")
            self.priorityTextField.text = index as? String
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
        
    }
    
    
    @IBAction func helptopicTextFieldClicked(_ sender: Any) {
        
        ActionSheetStringPicker.show(withTitle: "Select HelpTopic", rows: GlobalVariables.sharedManager.helpTopicNamesArray, initialSelection: 1, doneBlock: {
            picker, value, index in
            
            //  print("Values is : \(value)")
            //  print("index is : \(index ?? "")")
            
            print("Selected HelpTopic is : \(index ?? "No Value")")
            self.helpTopicTextField.text = index as? String
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
        
    }
    
    
    @IBAction func sourceTextFieldClicked(_ sender: Any) {
        
        ActionSheetStringPicker.show(withTitle: "Select Source", rows: GlobalVariables.sharedManager.sourceNamesArray, initialSelection: 1, doneBlock: {
            picker, value, index in
            
            //  print("Values is : \(value)")
            //  print("index is : \(index ?? "")")
            
            print("Selected Source is : \(index ?? "No Value")")
            self.sourceTextField.text = index as? String
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
        
    }
    
    
    @IBAction func slaTextFieldClicked(_ sender: Any) {
        
        ActionSheetStringPicker.show(withTitle: "Select SLA", rows: GlobalVariables.sharedManager.slaNameArray, initialSelection: 1, doneBlock: {
            picker, value, index in
            
            //  print("Values is : \(value)")
            //  print("index is : \(index ?? "")")
            
            print("Selected SLA is : \(index ?? "No Value")")
            self.slaTextField.text = index as? String
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
        
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }

    
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        SVProgressHUD.show(withStatus: "Updating Details")
        
        if subjectTextView.text == "" || subjectTextView.text.count == 0{
            
          showAlert(title: "Alert", message: "Please Enter Ticket Subject", vc: self)
          SVProgressHUD.dismiss()
        }
        else{
            
            //call API
            updateTicketDetailsAPICall()
        }
        
        

      
        
    } //end saveButtonClicked method
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if textView == subjectTextView {
            
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
    
    
    func updateTicketDetailsAPICall() {
       
        //Priority Value
        let priorityNamesArray2 = GlobalVariables.sharedManager.priorityNamesArray
        
        selectedPriorityId = NSNumber(value: 1 + priorityNamesArray2!.index(of: priorityTextField.text!)!) as? Int
        //  print("Selected Priority : %@ Id is : \(selectedPriorityId!)",priorityTextField.text!)
        
        //HelpTopic Value
        let helpTopicArray2 = GlobalVariables.sharedManager.helpTopicNamesArray
        
        selectedHelpTopicId = NSNumber(value: 1 + helpTopicArray2!.index(of: helpTopicTextField.text!)!) as? Int
        //  print("Selected HelpTopic : %@ Id is : \(selectedHelpTopicId!)",helpTopicTextField.text!)
        
        //Ticket Source Value
        let ticketSourcArray2 = GlobalVariables.sharedManager.sourceNamesArray
        
        selectedTicketSourceId = NSNumber(value: 1 + ticketSourcArray2!.index(of: sourceTextField.text!)!) as? Int
        //   print("Selected Source : %@ Id is : \(selectedTicketSourceId!)",sourceTextField.text!)
        
        //SLA Value
        let slaArray2 = GlobalVariables.sharedManager.slaNameArray
        
        selectedSLAId = NSNumber(value: 1 + slaArray2!.index(of: slaTextField.text!)!) as? Int
        //   print("Selected SLA : %@ Id is : \(selectedSLAId!)",slaTextField.text!)
        
        //Ticket status Value
        //   print("Tickety Status Id is : \(selectedTicketStatusId!)")
        
        
        let userDefaults = UserDefaults.standard
        
        var url:String = UserDefaults.standard.string(forKey: "baseURL") ?? ""
        url.append("api/v1/helpdesk/edit")
        
        let tokenValue = userDefaults.string(forKey:"token")
        
        let tickeId = GlobalVariables.sharedManager.ticketId
        let ticketSubject = subjectTextView.text
        
        requestPOSTURL(url, params: ["token":tokenValue as AnyObject,
                                     "ticket_id":tickeId as AnyObject,
                                     "subject":ticketSubject as AnyObject,
                                     "help_topic":selectedHelpTopicId as AnyObject,
                                     "ticket_priority":selectedPriorityId as AnyObject,
                                     "ticket_source":selectedTicketSourceId as AnyObject,
                                     "sla_plan":selectedSLAId as AnyObject,
                                     "status":selectedTicketStatusId as AnyObject,], success: { (data) in
                                        
                                        
                                        print("JSON is: ",data)
                                        
                                        let msg = data["message"].stringValue
                                        print("Message is: ",msg)
                                        
                                        if msg == "Token has expired"{
                                            
                                            tokenRefreshMethod()
                                            self.updateTicketDetailsAPICall()
                                        }
                                        else{
                                            
                                            
                                          let msg = data["result"]["success"].stringValue
                                          
                                            if msg == "Edited successfully"{
                                             
                                                print("I am in print - Ticket is Edited")
                                           
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
                                                    body: "Details are updated successfully..!",
                                                    viewController: navigationController
                                                )
                                                ////Showing Success Message End
                                                
                                                if self.globalVariable.fromVC == "myTickets"{
                                                   
                                                 let myTickets = self.storyboard!.instantiateViewController(withIdentifier: "MyTicketsViewControllerID") as! MyTicketsViewController
                                                    
                                                  self.navigationController?.pushViewController(myTickets, animated: true)
                                                    
                                                }
                                                else if self.globalVariable.fromVC == "unassignedTickets"{
                                                   
                                                  let unassignedTicketsVC = self.storyboard!.instantiateViewController(withIdentifier: "UnAssignedTicketsID") as! UnAssignedTickets
                                                    
                                                  self.navigationController?.pushViewController(unassignedTicketsVC, animated: true)
                                                }
                                                else if self.globalVariable.fromVC == "closedTickers"{
                                                   
                                                    let closedTicketsVC = self.storyboard!.instantiateViewController(withIdentifier: "ClosedTicketsID") as! ClosedTickets
                                                    
                                                   self.navigationController?.pushViewController(closedTicketsVC, animated: true)
                                                    
                                                }
                                                else if self.globalVariable.fromVC == "trashTickets"{
                                                    
                                                  let trashTicketsVC = self.storyboard!.instantiateViewController(withIdentifier: "TrashTicketsID") as! TrashTickets
                                                    
                                                  self.navigationController?.pushViewController(trashTicketsVC, animated: true)
                                                    
                                                }
                                                else{
                                                
                                                let inboxVC = self.storyboard!.instantiateViewController(withIdentifier: "InboxViewControllerID") as! InboxViewController
                                                    
                                                 self.navigationController?.pushViewController(inboxVC, animated: true)
                                                   
                                                }
                                                
                                                
                                            }
                                            else{
                                                
                                               showAlert(title: "Error", message: "Something went wrong. Please try again later.", vc: self)
                                               SVProgressHUD.dismiss()
 
                                            }
                                            
                                            
                                        }
                                        
        }) { (error) in
            
            //Example: After timeout error - The request timed out.
             print("Error From Edit Ticket API Method: \(error.localizedDescription)")
            
            showAlert(title: "Faveo Heldesk", message: error.localizedDescription, vc: self)
            SVProgressHUD.dismiss()
        }
        
    }
    
    
    
}
