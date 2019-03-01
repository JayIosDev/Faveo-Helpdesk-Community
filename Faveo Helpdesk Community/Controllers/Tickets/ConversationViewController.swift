//
//  ConversationViewController.swift
//  Faveo Helpdesk Community
//
//  Created by Mallikarjun on 10/01/19.
//  Copyright © 2019 Ladybird Web Solution. All rights reserved.
//

import UIKit

class ConversationData{
    
    let username:String
    let userfirstfame:String
    let userlastname:String
    let userprofilepicture:URL
    let createdat:String
    let body:String
    let isinternal:Int
   
    init(userName:String, userFirstName:String, userLastName:String, userProfilePicture:URL, createdAt:String, bodyMessage:String, isInternal:Int) {
        
        self.username = userName
        self.userfirstfame = userFirstName
        self.userlastname = userLastName
        self.userprofilepicture = userProfilePicture
        self.createdat = createdAt
        self.body = bodyMessage
        self.isinternal = isInternal
    }
    
}

class ConversationViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var skeltonView: UIView!
    
    @IBOutlet weak var skeltonImage1: UIImageView!
    
    @IBOutlet weak var skeltonImage2: UIImageView!
    
    @IBOutlet weak var skeltonImage3: UIImageView!
    
    @IBOutlet weak var skeltonImage4: UIImageView!
    
    @IBOutlet weak var skeltonImage5: UIImageView!
    
    
    
    
    
    
    
    var dataArray = [ConversationData]()
    var totalDataArray = [ConversationData]()
    var totalDataArray2 = [ConversationData]()
    
    let userDefaults = UserDefaults.standard
    
    //create an instance of the UIRefreshControl class
    private let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var sampleTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sampleTableView.isHidden = true
        skeltonImage1.loadGif(name: "skeltonGif")
        skeltonImage2.loadGif(name: "skeltonGif")
        skeltonImage3.loadGif(name: "skeltonGif")
        skeltonImage4.loadGif(name: "skeltonGif")
        skeltonImage5.loadGif(name: "skeltonGif")
        
        // Do any additional setup after loading the view.
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("reload"), object: nil)
        
        //tableViewcell
        sampleTableView.register(UINib(nibName: "ConversationTableViewCell", bundle: nil), forCellReuseIdentifier: "ConversationTableViewCellID")
        
        self.sampleTableView.tableFooterView = UIView()
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            sampleTableView.refreshControl = refreshControl
        } else {
            sampleTableView.addSubview(refreshControl)
        }
        
        // Configure Refresh Control
        self.configureRefreshControl()
        
        let valueFromRefreshTokenValue: String? = userDefaults.string(forKey: "valueFromRefreshToken")
        let userRoleValue: String? = userDefaults.string(forKey: "userRole")
        
        if userRoleValue == "user"{
            
            userDefaults.set("", forKey: "userRole")
            showLogoutAlert(title: "Access Denied", message: "Your role has beed changed to user. Contact to your Admin and try to login again.", vc: self)
            self.sampleTableView.isHidden = false
        }
        else if valueFromRefreshTokenValue == "Method not allowed" || valueFromRefreshTokenValue == "method not allowed"{
            
            userDefaults.set("", forKey: "valueFromRefreshToken")
            showLogoutAlert(title: "Access Denied", message: "Your HELPDESK URL were changed, contact to Admin and please log back in.", vc: self)
            self.sampleTableView.isHidden = false
        }
        else if valueFromRefreshTokenValue == "invalid_credentials" || valueFromRefreshTokenValue == "Invalid credential"{
            
            userDefaults.set("", forKey: "valueFromRefreshToken")
            showLogoutAlert(title: "Access Denied", message: "Your Login credentials were changed or Your Account is Deactivated, contact to Admin and please log back in.", vc: self)
            self.sampleTableView.isHidden = false
        }
        else{
              self.getTicketThread()
        }
        
    }
    

    
    func getTicketThread() {
        
        self.totalDataArray.removeAll()
        
        
        var ticketThreadURL = userDefaults.string(forKey: "baseURL")
        ticketThreadURL?.append("api/v1/helpdesk/ticket-thread")
        
        let defaults = UserDefaults.standard
        let value = defaults.string(forKey:"token")
        print("token=>",value!)
        
        let tickeId = GlobalVariables.sharedManager.ticketId
        
        requestGETURL(ticketThreadURL!, params: ["token":value as AnyObject,
                                            "id":tickeId as AnyObject],  success: { (data) in
                                                
                                                
                                                
          //  print("JSON is: ",data)
                                                
                                                
            let msg = data["message"].stringValue
            print("Message is: ",msg)
                                                
            if msg == "Token has expired"{
                                                    
               tokenRefreshMethod()
               self.getTicketThread()
            }
            else{
                                                    
                var dataIterator = 0
                
                self.dataArray.removeAll()
                self.totalDataArray.removeAll()
                
                for dataList in data.arrayValue{
                    
                    let messageBody = dataList["body"].stringValue
                    let createdate = dataList["created_at"].stringValue
                    let firstNameValue = dataList["first_name"].stringValue
                    let lastNameValue = dataList["last_name"].stringValue
                    var userNameValue = dataList["user_name"].stringValue
                    let profilePicture = dataList["profile_pic"].url
                    let internalNoteValue = dataList["is_internal"].intValue
                    
                    if firstNameValue == "" && lastNameValue == ""{
                        
                        if userNameValue == ""{
                            
                            userNameValue = "System"
                        }
                        else{
                            userNameValue = "\(userNameValue)"
                        }
                        
                        
                    }
                    else if firstNameValue == "" || lastNameValue == ""{
                        
                        userNameValue = "\(firstNameValue)\(" ") \(lastNameValue)"
                    }
                
                    
                    self.dataArray.append(ConversationData(userName: userNameValue, userFirstName: firstNameValue, userLastName: lastNameValue, userProfilePicture: profilePicture!, createdAt: createdate, bodyMessage: messageBody, isInternal: internalNoteValue))
                    
                    
                    self.totalDataArray = self.dataArray
                    
                    dataIterator = dataIterator + 1
                    
                    
                } // End - for dataList
                                                    
                self.sampleTableView.isHidden = false

                  DispatchQueue.main.async {
                   
                     self.sampleTableView.reloadData()
                     self.refreshControl.endRefreshing()
                    self.sampleTableView.isHidden = false
                  }
                                                    
            }//end else condition of - if msg == "Token expired"{
                                                
                                                
                                                
        }) { (error) in
            
            //Example: After timeout error - The request timed out.
            print("Error From Getting Conversations API Call: \(error.localizedDescription)")
            
            showAlert(title: "Faveo Heldesk", message: error.localizedDescription, vc: self)
            self.sampleTableView.isHidden = false

        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        var numberOfSections:Int = 0
        
        if totalDataArray.count == 0{
            
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = NSLocalizedString("No Records..!!!", comment: "")
            noDataLabel.textColor = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = .none
            
            
        }else{
            
            tableView.separatorStyle = .singleLine
            numberOfSections = 1
            tableView.backgroundView = nil
            
        }
        return numberOfSections
    }
    
    //Tells the data source to return the number of rows in a given section of a table view.
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return totalDataArray.count
    
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
//        cell.layer.transform = rotationTransform
//
//        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseOut, animations: {
//            cell.layer.transform = CATransform3DIdentity
//
//        })
        
        cell.selectionStyle = .none
        
    }
    
    
    //Asks the data source for a cell to insert in a particular location of the table view.
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if indexPath.row == totalDataArray.count {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "LoadingTableViewCellID") as? LoadingTableViewCell
            if cell == nil {
                var nib = Bundle.main.loadNibNamed("LoadingTableViewCell", owner: self, options: nil)
                cell = nib?[0] as? LoadingTableViewCell
            }
            let activityIndicator = cell?.contentView.viewWithTag(1) as? UIActivityIndicatorView
            activityIndicator?.startAnimating()
            return cell!
        }
        else{
            
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationTableViewCellID", for: indexPath) as! ConversationTableViewCell
        
        
        //username
        var  firstName = totalDataArray[indexPath.row].userfirstfame
        let  lastName = totalDataArray[indexPath.row].userlastname
        let userName = totalDataArray[indexPath.row].username
    
         firstName.append(" ")
         firstName.append(lastName) //Full Name
        
        
        if firstName.isEmpty && lastName.isEmpty{
            
            if userName.isEmpty{

                cell.nameLabel.text = "System"
                
            }
            else{
                 cell.nameLabel.text = userName
                
            }
        }
        else {
            
            cell.nameLabel.text = firstName
        }
        
        //Profile Image
        let imageUrl = totalDataArray[indexPath.row].userprofilepicture
        
        if imageUrl.absoluteString.hasSuffix("system.png") || imageUrl.absoluteString.hasSuffix(".jpg") || imageUrl.absoluteString.hasSuffix(".jpeg") || imageUrl.absoluteString.hasSuffix(".png"){
            
            cell.setUserProfileimage(imageUrl: imageUrl)
        }
        else{
            
            if firstName.isEmpty && lastName.isEmpty{
                
                if userName.isEmpty{
                    
                   
                    cell.profilePicture.setImage(string: "System", color: UIColor.colorHash(name: "System"), circular: true)
                }
                else{
                    
                    cell.profilePicture.setImage(string: userName, color: UIColor.colorHash(name: userName), circular: true)
                }
                
            }
            else {
                
                 cell.profilePicture.setImage(string: firstName, color: UIColor.colorHash(name: firstName), circular: true)
            }
            
           
        }
        
        //created time
          cell.dateLabel.text = getLocalDateTimeFromUTC(strDate: totalDataArray[indexPath.row].createdat)
    
        //Checking that this message is reply or internal note
        
        if totalDataArray[indexPath.row].isinternal == 0{
            
            cell.internalNoteLabel.isHidden = true
        }
        else{
            cell.internalNoteLabel.isHidden = false
            
        }
        
        //body
        
        let body:String = totalDataArray[indexPath.row].body

        cell.webView?.translatesAutoresizingMaskIntoConstraints = false
        cell.webView?.loadHTMLString(body, baseURL: nil)
        
        
        return cell
            
        }
        
    }
    
    
   // private var cellExpand: Bool = false
    var selectedIndex:Int = -1
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        //user taps expnmade view
        
        
        if selectedIndex == indexPath.row {
            
            selectedIndex = -1
            if let array = [indexPath] as? [IndexPath] {
                tableView.reloadRows(at: array, with: .fade)
            }
            return
        }
        
        //user taps diff row
        if selectedIndex != -1 {
            
            let prevPath = IndexPath(row: selectedIndex, section: 0)
            selectedIndex = Int(indexPath.row)
            
            tableView.reloadRows(at: [prevPath], with: .fade)
        }
        
        
        //uiser taps new row with none expanded
        selectedIndex = Int(indexPath.row)
        if let array = [indexPath] as? [IndexPath] {
            tableView.reloadRows(at: array, with: .fade)
        }

        /*
         //Another method to exapand cell - Part I
         
         selectedIndex = indexPath.row
         
         if cellExpand {
         cellExpand = false
         } else {
         cellExpand = true
         }
         tableView.beginUpdates()
         tableView.endUpdates()
         */
        
        
        
    }
    
    //tableview height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
        if selectedIndex == indexPath.row {
            return 250
        } else {
            return 115
            
        }
    }
       
      //Another method to exapand cell - Part II
      /*
          if selectedIndex == indexPath.row {

              if cellExpand{
                 return 250
              }
              else {
                  return 85
              }
          }
            else
          {

              return 90
          }
       */
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        
        self.getTicketThread()
    }

    //UIRefresh Control Configuration
    
    func configureRefreshControl(){
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .center
        
        
        let refreshing = NSAttributedString(string: NSLocalizedString("Refreshing", comment: ""), attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18),
            NSAttributedString.Key.paragraphStyle:paragraphStyle,
            NSAttributedString.Key.foregroundColor: UIColor.white
            ])
        
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        refreshControl.backgroundColor =  UIColor(red:0.46, green:0.8, blue:1.0, alpha:1.0)
        
        refreshControl.attributedTitle = refreshing
        refreshControl.tintColor = UIColor.white
        
    }
    
    
    @objc private func refreshTableView() {
        
        DispatchQueue.main.async {
            
            print("Refresh TableView Called")
            self.getTicketThread()
            
        }
    }

}

