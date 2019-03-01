//
//  UsersDetailsViewController.swift
//  Faveo Helpdesk Community
//
//  Created by Mallikarjun on 17/01/19.
//  Copyright © 2019 Ladybird Web Solution. All rights reserved.
//

import UIKit
import SVProgressHUD


class UsersTicketsDataList{
    
    let ticketId:Int
    let ticketNumber:String
    let ticketStatus:String
    let ticketTitle:String
 
    init(ticketid:Int, ticketnumber:String, ticketstatus:String,title:String) {
        
      self.ticketId = ticketid
      self.ticketNumber = ticketnumber
      self.ticketStatus = ticketstatus
      self.ticketTitle = title
      
    }
    
}


class UsersDetailsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var backGroundImage: UIImageView!
    
    @IBOutlet weak var skeltonView: UIView!
    @IBOutlet weak var skeltonGifImage: UIImageView!
    
   
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    @IBOutlet weak var userProfilePicture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userStateLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    
    var dataArray = [UsersTicketsDataList]()
    var totalDataArray = [UsersTicketsDataList]()
    var totalDataArray2 = [UsersTicketsDataList]()
    
    
    
    let userDefaults = UserDefaults.standard
    var globalVariables = GlobalVariables.sharedManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backGroundImage.loadGif(name: "background")

        skeltonGifImage.loadGif(name: "UserDetailGif")
        
        // to set black background color mask for Progress view
        //tableViewcell
        tableViewOutlet.register(UINib(nibName: "UsersAssociatedTickets", bundle: nil), forCellReuseIdentifier: "UsersAssociatedTicketsID")
        
        tableViewOutlet.tableFooterView = UIView()
        
        let userFullName = globalVariables.firstNameFromUserList
        let userName = globalVariables.userNameFromUserList
        let userEmailId = globalVariables.emailFromUserList
        let userProfile = globalVariables.profilePictureFromUserList
        let userState:Int = globalVariables.userStateFromUserList ?? 2
        let mobileCode:Int = globalVariables.mobileCodeFromUserList ?? 0
        let mobileNumber:Int = globalVariables.mobileNumberFromUserList ?? 0
        
        //User Full Name
        if userFullName == ""{
            
            if userName != ""{
                
                nameLabel.text = userName
            }
            
        }
        else{
            
            nameLabel.text = userFullName
        }
        
        //User ProfilePicture
        
        if userProfile!.absoluteString.hasSuffix("system.png") || userProfile!.absoluteString.hasSuffix(".jpg") || userProfile!.absoluteString.hasSuffix(".jpeg") || userProfile!.absoluteString.hasSuffix(".png"){
            
            let data = try? Data(contentsOf: userProfile!)
            
            if let imageData = data {
                let image = UIImage(data: imageData)
                userProfilePicture.image = image
            }
            
        }
        else{
            
            userProfilePicture.setImage(string: userFullName, color: UIColor.colorHash(name: userFullName), circular: true)
        }
        
       
        
        //Email id
        if userEmailId != "" {
        
            emailLabel.text = userEmailId
        }
        else{
            emailLabel.text = "Not Available"
        }
        
        // MobileNumber
        
        if mobileNumber  > 0 && mobileCode > 0{
            
            let mobile = String(mobileNumber)
            let code = String(mobileCode)
            
            mobileLabel.text = "+\(code) \((mobile))"
        }
        else{
            mobileLabel.text = "Not Available"
        }
        
        //UserStatus
        if userState == 1{
            
            userStateLabel.text = "ACTIVE"
        }
        else{
            
            userStateLabel.text = "INACTIVE"
        }
        
        
        //Get Tickets Associated with this user
         getTicketsAssociatedWithTheUser()
        
        
        
    }
    
    
    func getTicketsAssociatedWithTheUser() {
        
        var getUsersTickets = userDefaults.string(forKey: "baseURL")
        getUsersTickets?.append("api/v1/helpdesk/my-tickets-user")
        
        let userId = globalVariables.userIdFromUserList
        
        let tokenValue = userDefaults.string(forKey:"token")
        // print("token=>",tokenValue!)
        
        requestGETURL(getUsersTickets!, params: ["token":tokenValue as AnyObject, "user_id":userId as AnyObject],  success: { (data) in
            
            
          //  print("Inbox JSON is: ",data)
            
            let msg = data["message"].stringValue
            print("Message is: ",msg)
            
            if msg == "Token has expired"{
                
                tokenRefreshMethod()
                self.getTicketsAssociatedWithTheUser()
            }
            else{
                
                 var dataIterator = 0
                
                for dataList in data["tickets"].arrayValue{
                    
                    let ticketId1 = dataList["id"].intValue
                    let ticketNumber = dataList["ticket_number"].stringValue
                    let ticketStatus = dataList["ticket_status_name"].stringValue
                    let ticketTitle = dataList["title"].stringValue
        
                    
                    self.dataArray.append(UsersTicketsDataList(ticketid: ticketId1, ticketnumber: ticketNumber, ticketstatus: ticketStatus, title:ticketTitle))
                    
                    self.totalDataArray = self.dataArray
                    
                    dataIterator = dataIterator + 1
                    
                    
                } // End - for dataList
                
                
                DispatchQueue.main.async {
                    self.tableViewOutlet.reloadData()

                   self.skeltonView.isHidden = true
                    
                }
                
            } // End of - else of if msg
            
            
            
        }) { (error) in
            
            //Example: After timeout error - The request timed out.
            print("Error From Users Details API Call: \(error.localizedDescription)")
            
            showAlert(title: "Faveo Heldesk", message: error.localizedDescription, vc: self)
            self.skeltonView.isHidden = true

        }
        
    }//end getTicketsAssociatedWithTheUser()
    
  
    
    //Tells the data source to return the number of rows in a given section of a table view.
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return totalDataArray.count
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
        cell.layer.transform = rotationTransform
        
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseOut, animations: {
            cell.layer.transform = CATransform3DIdentity
            
        })
        
        cell.selectionStyle = .none
        
    }
    
    
    //Asks the data source for a cell to insert in a particular location of the table view.
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersAssociatedTicketsID", for: indexPath) as! UsersAssociatedTickets
       
        
        cell.ticketNumber.text = totalDataArray[indexPath.row].ticketNumber
        cell.ticketSubject.text = totalDataArray[indexPath.row].ticketTitle
        
        let colorValue:String?
        if totalDataArray[indexPath.row].ticketStatus == "Open"{
            
            colorValue = "#4CD964"
        }
        else{
             colorValue = "#d50000"
        }
        cell.setPriorityColor(color: colorValue!)
        
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        globalVariables.firstName = globalVariables.firstNameFromUserList ?? ""
        globalVariables.ticketNumber = totalDataArray[indexPath.row].ticketNumber
        globalVariables.ticketStatus =  totalDataArray[indexPath.row].ticketStatus 
        globalVariables.ticketId =  totalDataArray[indexPath.row].ticketId
        
        
        let detailView = self.storyboard?.instantiateViewController(withIdentifier: "TicketDetailsViewControllerID") as! TicketDetailsViewController
        
        self.navigationController?.pushViewController(detailView, animated: true)
        
    }
    
}
