//
//  DetailsViewController.swift
//  Faveo Helpdesk Community
//
//  Created by Mallikarjun on 11/01/19.
//  Copyright © 2019 Ladybird Web Solution. All rights reserved.
//

import UIKit
import SVProgressHUD


class DetailsViewController: UITableViewController {

  
    let userDefaults = UserDefaults.standard
    @IBOutlet var sampleTableView: UITableView!
    @IBOutlet weak var subjectTextView: UITextView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sourceTextField: UITextField!
    @IBOutlet weak var departmentTextField: UITextField!
    @IBOutlet weak var assigneeName: UITextField!
    @IBOutlet weak var slaTextField: UITextField!
    @IBOutlet weak var createdTextField: UITextField!
    @IBOutlet weak var lastResponseTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        subjectTextView.isEditable = false

        self.tableView.tableFooterView = UIView()
        
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
             //    print("JSON is: ",data)
                                                    
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
                
                    //ticket owner name
                     var firstName = data["result"]["first_name"].stringValue
                     let lastName = data["result"]["last_name"].stringValue
                
                    if firstName.isEmpty && lastName.isEmpty{
                        
                        self.nameTextField.text = "Not Available"
                    }else{
                        firstName.append(" ")
                        firstName.append(lastName)
                        
                        self.nameTextField.text = firstName
                    }
                    
                    //ticket owner email
                    let emailId = data["result"]["email"].stringValue
                    
                    if emailId.isEmpty {
                        
                        self.emailTextField.text = "Not Available"
                    }else{
                        
                        self.emailTextField.text = emailId
                    }
                  
                    //ticket source
                    
                    let ticketSource = data["result"]["source_name"].stringValue
                    
                    if ticketSource.isEmpty {
                        
                        self.sourceTextField.text = "Not Available"
                    }else{
                        
                        self.sourceTextField.text = ticketSource
                    }
                    
                    // ticket department
                    
                    let departmentName = data["result"]["dept_name"].stringValue
                    
                    if departmentName.isEmpty {
                        
                        self.departmentTextField.text = "Not Available"
                    }else{
                        
                        self.departmentTextField.text = departmentName
                    }
                    
                    //assignee
                    
                    let assigneeName = data["result"]["assignee"].stringValue
                    
                    if assigneeName.isEmpty {
                        
                        self.assigneeName.text = "Not Available"
                    }else{
                        
                        self.assigneeName.text = assigneeName
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

                
                    //created date
                    
                    let createdDate = data["result"]["created_at"].stringValue
                    
                    if createdDate.isEmpty  {
                     //  print(" create date is empty")
                        self.createdTextField.text = "Not Available"
                    }else{
                      //  print(" date is not empty")
                        self.createdTextField.text = getLocalDateTimeFromUTC(strDate: createdDate)

                    }
                    
                  //last updated date
                    
                    let lastUpdatedDate = data["result"]["updated_at"].stringValue
                    
                    if lastUpdatedDate.isEmpty {
                      //  print(" updated date is empty")
                        self.lastResponseTextField.text = "Not Available"
                    }else{
                     //  print(" updated date is not empty")
                        self.lastResponseTextField.text = getLocalDateTimeFromUTC(strDate: lastUpdatedDate)
                        
                    }
                    
                 } // End else of ....if msg == "Token expired"
                                                    
//                self.sampleTableView.isHidden = false
        }) { (error) in
            
            //Example: After timeout error - The request timed out.
            print("Error From Details of Ticket API Call: \(error.localizedDescription)")
            
            showAlert(title: "Faveo Heldesk", message: error.localizedDescription, vc: self)
//            self.sampleTableView.isHidden = false

        }
        
    }
    
    
    
    

}
