//
//  TrashTickets.swift
//  Faveo Helpdesk Community
//
//  Created by Mallikarjun on 15/01/19.
//  Copyright © 2019 Ladybird Web Solution. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftHEXColors
import RMessage

class TrashTickets: UIViewController,UITableViewDataSource,UITableViewDelegate,RMControllerDelegate{

    
    var selectedPath:IndexPath?
    var selectedTicketId:String?
    var selectedIdCount:Int?
    
    
    //RMessage
    private let rControl = RMController()
    
    //create an instance of the UIRefreshControl class
    private let refreshControl = UIRefreshControl()
    
    var sampleArray:Array<String> = Array<String>()
    var dataArray = [DataList]()
    var totalDataArray = [DataList]()
    var totalDataArray2 = [DataList]()
    
    var nextPageURL:String?
    var currentPage:Int?
    var totalTickets:Int?
    var totalPages:Int?
    
    let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var sampleTableView: UITableView!
    @IBOutlet weak var sideMenuButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // to set black background color mask for Progress view
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.dismiss()
        
        //RMessage
        rControl.presentationViewController = self
        rControl.delegate = self
        
        // Do any additional setup after loading the view.
        setUpSideMenuBar()
        
        self.sampleTableView.tableFooterView = UIView()
        
        //tableViewcell
        sampleTableView.register(UINib(nibName: "TicketTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
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
            SVProgressHUD.dismiss()
        }
        else if valueFromRefreshTokenValue == "Method not allowed" || valueFromRefreshTokenValue == "method not allowed"{
            
            userDefaults.set("", forKey: "valueFromRefreshToken")
            showLogoutAlert(title: "Access Denied", message: "Your HELPDESK URL were changed, contact to Admin and please log back in.", vc: self)
            SVProgressHUD.dismiss()
        }
        else if valueFromRefreshTokenValue == "invalid_credentials" || valueFromRefreshTokenValue == "Invalid credential"{
            
            userDefaults.set("", forKey: "valueFromRefreshToken")
            showLogoutAlert(title: "Access Denied", message: "Your Login credentials were changed or Your Account is Deactivated, contact to Admin and please log back in.", vc: self)
            SVProgressHUD.dismiss()
        }
        else{
            SVProgressHUD.show(withStatus: "Getting Tickets")
            // call get ticket api
            getTickets()
            
        }
    }
    
    //setting up side-menu bar
    func setUpSideMenuBar(){
        
        if revealViewController() != nil{
            
            sideMenuButton.target = revealViewController()
            sideMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            revealViewController()?.rearViewRevealWidth = 320 //280 
            // revealViewController()?.rightViewRevealWidth = 160
            
            view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        }
        
    }// End of setUpSideMenuBar method
    
    
    
    
    func getTickets(){
        
        var getInboxTicketsURL = userDefaults.string(forKey: "baseURL")
        getInboxTicketsURL?.append("api/v1/helpdesk/trash")
        
        let tokenValue = userDefaults.string(forKey:"token")
        // print("token=>",tokenValue!)
        
        requestGETURL(getInboxTicketsURL!, params: ["token":tokenValue as AnyObject ],  success: { (data) in
            
            
         //   print("Inbox JSON is: ",data)
            
            let msg = data["message"].stringValue
            print("Message is: ",msg)
            
            if msg == "Token has expired"{
                
                tokenRefreshMethod()
                self.getTickets()
            }
            else{
                
                self.nextPageURL = data["next_page_url"].stringValue
                self.currentPage = data["current_page"].intValue
                self.totalTickets = data["total"].intValue
                self.totalPages = data["last_page"].intValue
                
                var dataIterator = 0
                
                self.dataArray.removeAll()
                self.totalDataArray.removeAll()
                
                for dataList in data["data"].arrayValue{
                    
                    let ticketSubject = dataList["title"].stringValue
                    let ticketUpdatedDate1 = dataList["updated_at"].stringValue
                    let ticketOverdueDate = dataList["overdue_date"].stringValue
                    let ticketNumber = dataList["ticket_number"].stringValue
                    let firstname = dataList["first_name"].stringValue
                    let lastname = dataList["last_name"].stringValue
                    
                    var userFullName:String
                    
                    if firstname == "" && lastname == ""{
                        userFullName = "Unassigned"
                    }else{
                        userFullName = "\(firstname)\(" ") \(lastname)"
                    }
                    
                    let email = dataList["email"].stringValue
                    let userProfilePic1 = dataList["profile_pic"].url
                    let ticketPriority = dataList["priority_color"].stringValue
                    
                    
                    let ticketId1 = dataList["id"].intValue
                    let ticketStatus1 = dataList["ticket_status_name"].stringValue
                    
                    self.dataArray.append(DataList(ticketNumber: ticketNumber, userName: userFullName, Emails: email, ticketSubject: ticketSubject, userProfilePicture:userProfilePic1!,priorityColor:ticketPriority, ticketUpdatedDate:ticketUpdatedDate1, overDueDate:ticketOverdueDate, ticketStatus:ticketStatus1, ticketId:ticketId1))
                    
                    self.totalDataArray = self.dataArray
                    
                    dataIterator = dataIterator + 1
                    
                    
                } // End - for dataList
                
                
                DispatchQueue.main.async {
                    self.sampleTableView.reloadData()
                    self.refreshControl.endRefreshing()
                    SVProgressHUD.dismiss()
                }
                
            } // End of - else of if msg
            
            
            
        }) { (error) in
            
            //Example: After timeout error - The request timed out.
            print("Error From Trash Tickets API Call: \(error.localizedDescription)")
            
            showAlert(title: "Faveo Heldesk", message: error.localizedDescription, vc: self)
            SVProgressHUD.dismiss()

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
       
        if totalDataArray.count == 0{
            
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = NSLocalizedString("No Records..!!!", comment: "")
            noDataLabel.textColor = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = .none
            
        }else{
            
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
            
        }
        
        if currentPage == totalPages || totalTickets == totalDataArray.count {
            return totalDataArray.count
        }
        
        return totalDataArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.selectionStyle = .none
        
        if indexPath.row == totalDataArray.count - 1 {
            print("nextURL is: \(nextPageURL ?? "null")")
            
            if nextPageURL != nil && !nextPageURL!.isEmpty {
                
                // loadMore()
                getNextPageTickets(nextPageUrl: nextPageURL!)
                print("There are more tickets")
            }
            else {
                print("There is no more tickets")
                
                var iconSpec = successSpec
                iconSpec.iconImage = UIImage(named: "SuccessMessageIcon")
                
                self.rControl.showMessage(
                    withSpec: iconSpec,
                    atPosition: .bottom, // .top // .bottom
                    title: "",
                    body: "All Caught Up",
                    viewController: self
                )
                
            }
        }
        
    }
    
    
    func getNextPageTickets(nextPageUrl:String){
        
        let tokenValue = userDefaults.string(forKey:"token")
        print("token=>",tokenValue!)
        
        var nextURLString = nextPageUrl
        nextURLString.append("&token=")
        nextURLString.append(tokenValue!)
        
        print("Next Page URL is: \(nextURLString)")
        
        requestGETURL(nextURLString, params: nil,  success: { (data) in
            
            print(URLRequest.self)
            
            
            //  print("JSON is: ",data)
            
            let msg = data["message"].stringValue
            print("Message is: ",msg)
            
            if msg == "Token has expired"{
                
                tokenRefreshMethod()
                self.getNextPageTickets(nextPageUrl: self.nextPageURL!)
            }
            else{
                
                self.nextPageURL = data["next_page_url"].stringValue
                self.currentPage = data["current_page"].intValue
                self.totalTickets = data["total"].intValue
                self.totalPages = data["last_page"].intValue
                
                var dataIterator = 0
                
                for dataList in data["data"].arrayValue{
                    
                    let ticketSubject = dataList["title"].stringValue
                    let ticketUpdatedDate1 = dataList["updated_at"].stringValue
                    let ticketOverdueDate = dataList["overdue_date"].stringValue
                    let ticketNumber = dataList["ticket_number"].stringValue
                    let firstname = dataList["first_name"].stringValue
                    let lastname = dataList["last_name"].stringValue
                    
                    var userFullName:String
                    
                    if firstname == "" && lastname == ""{
                        userFullName = "Unassigned"
                    }else{
                        userFullName = "\(firstname)\(" ") \(lastname)"
                    }
                    
                    let email = dataList["email"].stringValue
                    let userProfilePic1 = dataList["profile_pic"].url
                    let ticketPriority = dataList["priority_color"].stringValue
                    
                    
                    let ticketId1 = dataList["id"].intValue
                    let ticketStatus1 = dataList["ticket_status_name"].stringValue
                    
                    
                    self.dataArray.append(DataList(ticketNumber: ticketNumber, userName: userFullName, Emails: email, ticketSubject: ticketSubject, userProfilePicture:userProfilePic1!,priorityColor:ticketPriority, ticketUpdatedDate:ticketUpdatedDate1, overDueDate:ticketOverdueDate, ticketStatus: ticketStatus1, ticketId: ticketId1))
                    
                    self.totalDataArray = self.dataArray
                    // self.totalDataArray2 = self.dataArray
                    
                    dataIterator = dataIterator + 1
                    
                    
                } // End - for dataList
                
                
                // self.totalDataArray.append(contentsOf: self.totalDataArray2)
                
                DispatchQueue.main.async {
                    self.sampleTableView.reloadData()
                    self.refreshControl.endRefreshing()
                    SVProgressHUD.dismiss()
                }
                
            } // End of - else of if msg
            
            
            
        }) { (error) in
            
            print(error)
        }
        
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
        else {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TicketTableViewCell
        
        cell.ticketNumber.text = totalDataArray[indexPath.row].ticketnumber
        cell.ticketOwnerName.text = totalDataArray[indexPath.row].username
        cell.ticketSubject.text = totalDataArray[indexPath.row].ticketsubject
        cell.setUserProfileimage(imageUrl:totalDataArray[indexPath.row].userprofilepicture )
        cell.setPriorityColor(color: totalDataArray[indexPath.row].prioritycolor)
        cell.timeStampLabel.text = getLocalDateTimeFromUTC(strDate: totalDataArray[indexPath.row].ticketupdateddate)
        
        //username
        let name = totalDataArray[indexPath.row].username
        //Profile Image
        let imageUrl = totalDataArray[indexPath.row].userprofilepicture
        
        if imageUrl.absoluteString.hasSuffix("system.png") || imageUrl.absoluteString.hasSuffix(".jpg") || imageUrl.absoluteString.hasSuffix(".jpeg") || imageUrl.absoluteString.hasSuffix(".png"){
            
            cell.setUserProfileimage(imageUrl: imageUrl)
        }
        else{
            
            cell.userProfilePicture.setImage(string: name, color: UIColor.colorHash(name: name), circular: true)
        }
        
        if compareDates(strDate:totalDataArray[indexPath.row].overduedate){
            
            cell.overDue.isHidden = false
            cell.dueToday.isHidden = true
            
        }else{
            cell.overDue.isHidden = true
            cell.dueToday.isHidden = false
        }
        
        return cell
        
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        
        GlobalVariables.sharedManager.firstName = totalDataArray[indexPath.row].username
        //   GlobalVariables.sharedManager.lastName = totalDataArray[indexPath.row].ticketnumber
        GlobalVariables.sharedManager.ticketNumber = totalDataArray[indexPath.row].ticketnumber
        GlobalVariables.sharedManager.ticketStatus = totalDataArray[indexPath.row].ticketstatus
        GlobalVariables.sharedManager.ticketId = totalDataArray[indexPath.row].ticketid
        
        GlobalVariables.sharedManager.fromVC = "trashTickets"
        
        let detailView = self.storyboard?.instantiateViewController(withIdentifier: "TicketDetailsViewControllerID") as! TicketDetailsViewController
        
        self.navigationController?.pushViewController(detailView, animated: true)
        
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
            
            self.getTickets()
            
        }
    }
    

}
