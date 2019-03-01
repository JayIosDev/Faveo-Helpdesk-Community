//
//  SideMenuBarVC.swift
//  Faveo Helpdesk Community
//
//  Created by Mallikarjun on 05/01/19.
//  Copyright © 2019 Ladybird Web Solution. All rights reserved.
//

import UIKit
import RMessage

class SideMenuBarVC: UITableViewController,RMControllerDelegate {
    @IBOutlet weak var backGroundImage: UIImageView!
    
    @IBOutlet var tableViewOutlet: UITableView!
    
    
    @IBOutlet weak var userProfilePicture: UIImageView!
    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    let userDefaults = UserDefaults.standard
 
    //RMessage
    private let rControl = RMController()
    
    private let refreshControl1 = UIRefreshControl()
    
    @IBOutlet weak var inboxCountView: UIView!
    @IBOutlet weak var myTicketsCountView: UIView!
    @IBOutlet weak var unassignedCountView: UIView!
    @IBOutlet weak var closedCountView: UIView!
    @IBOutlet weak var trashCountView: UIView!
    
    @IBOutlet weak var inboxLabel: UILabel!
    @IBOutlet weak var myTicketsCountLabel: UILabel!
    @IBOutlet weak var unassignedCountLabel: UILabel!
    @IBOutlet weak var closedCountLabel: UILabel!
    @IBOutlet weak var trashCountLabel: UILabel!
    
    
    //Priority
    var prioritiesNamesArray = [String]()
    var prioritiesIdArray = [Int]()
    //HelpTopcis
    var helptopicsNamesArray = [String]()
    var helptopicsIdArray = [Int]()
    //Ticket Source
    var ticketSourcesNamesArray = [String]()
    var ticketSourcesIdArray = [Int]()
    //SLA
    var slaNamesArray = [String]()
    var slaIdsArray = [Int]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        backGroundImage.loadGif(name: "background1")
        //RMessage
        rControl.presentationViewController = self
        rControl.delegate = self
        
        // to set black background color mask for Progress view
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableViewOutlet.refreshControl = refreshControl1
        } else {
            tableViewOutlet.addSubview(refreshControl!)
        }
        
        // Configure Refresh Control
        self.configureRefreshControl()
        
        //This will remove extra separators from tableview
        self.tableView.tableFooterView = UIView()
        
        getDependeciesAPICall()
        showLoggedUserProfileDetails()
        
        
    }



    // Show info
    func showLoggedUserProfileDetails() {
        
      let userfullname = userDefaults.string(forKey: "userFullName")
      userFullName.text = userfullname
        
      userEmail.text = userDefaults.string(forKey: "userEmail")
        
      let userProfilePicture = userDefaults.string(forKey: "userProfilePic")
       
        if userProfilePicture!.hasSuffix("system.png") || userProfilePicture!.hasSuffix(".jpg") || userProfilePicture!.hasSuffix(".jpeg") || userProfilePicture!.hasSuffix(".png"){
            
            let imageURLString = URL(string: userProfilePicture!)
            setUserProfileimage(imageUrl: imageURLString!)
        }
        else{
            
            self.userProfilePicture.setImage(string: userfullname, color: UIColor.colorHash(name: userfullname), circular: true)
        }
        
        
        //Inbox
        inboxCountView.alpha = 0.5
        inboxCountView.layer.cornerRadius = 20
        
        let openCount:Int = GlobalVariables.sharedManager.openTicketsCount ?? 00
        if openCount > 99{
            inboxLabel.text = "99+"
        }
        else if openCount < 10{
             inboxLabel.text = "0" + "\(String(openCount))"
        }
        else{
              inboxLabel.text = String(openCount)
        }
        
        
        //My Tickets
        myTicketsCountView.alpha = 0.5
        myTicketsCountView.layer.cornerRadius = 20
        
        let myTicketsCount:Int = GlobalVariables.sharedManager.myTicketsCount ?? 00
        if myTicketsCount > 99{
            myTicketsCountLabel.text = "99+"
        }
        else if myTicketsCount < 10{
            myTicketsCountLabel.text = "0" + "\(String(myTicketsCount))"
        }
        else{
            myTicketsCountLabel.text = String(myTicketsCount)
        }
        
        //Unassigned Tickets
        unassignedCountView.alpha = 0.5
        unassignedCountView.layer.cornerRadius = 20
        
        let unassignedTicketsCount:Int = GlobalVariables.sharedManager.unassignedTicketsCount ?? 00
        if unassignedTicketsCount > 99{
            unassignedCountLabel.text = "99+"
        }
        else if unassignedTicketsCount < 10{
            unassignedCountLabel.text = "0" + "\(String(unassignedTicketsCount))"
        }
        else{
            unassignedCountLabel.text = String(unassignedTicketsCount)
        }
        
        
        //Closed Tickets
        closedCountView.alpha = 0.5
        closedCountView.layer.cornerRadius = 20

        let closedTicketsCount:Int = GlobalVariables.sharedManager.closedTicketsCount ?? 00
        if closedTicketsCount > 99{
            closedCountLabel.text = "99+"
        }
        else if closedTicketsCount < 10{
            closedCountLabel.text = "0" + "\(String(closedTicketsCount))"
        }
        else{
            closedCountLabel.text = String(closedTicketsCount)
        }
        
        //Trash tickets
        trashCountView.alpha = 0.5
        trashCountView.layer.cornerRadius = 20
        
        let trashTicketsCount:Int = GlobalVariables.sharedManager.deletedTicketsCount ?? 00
        if trashTicketsCount > 99{
            trashCountLabel.text = "99+"
        }
        else if trashTicketsCount < 10{
            trashCountLabel.text = "0" + "\(String(trashTicketsCount))"
        }
        else{
            trashCountLabel.text = String(trashTicketsCount)
        }
        
        self.refreshControl1.endRefreshing()
    }
    
    func setUserProfileimage(imageUrl:URL) {
        
        let data = try? Data(contentsOf: imageUrl)
        
        if let imageData = data {
            let image = UIImage(data: imageData)
            userProfilePicture.image = image
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tableViewOutlet.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       // print(indexPath.row)
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        if indexPath.section == 0{
          
            //Index 0 - Create Ticket
            
            if indexPath.row == 0 {
                
                let createTicketVC = mainStoryboard.instantiateViewController(withIdentifier: "CreateTicketViewControllerID") as! CreateTicketViewController
                
                let navigation: SampleNavigation = SampleNavigation(rootViewController: createTicketVC)
                
                let sidemenu = mainStoryboard.instantiateViewController(withIdentifier: "SideMenuBarVCID") as? SideMenuBarVC
                
                let vc = SWRevealViewController(rearViewController: sidemenu, frontViewController: navigation)
                
                self.present(vc!, animated: true, completion: nil)
                
            }
            if indexPath.row == 1 {
                
                let inboxVC = mainStoryboard.instantiateViewController(withIdentifier: "InboxViewControllerID") as! InboxViewController
                
                let navigation: SampleNavigation = SampleNavigation(rootViewController: inboxVC)
                
                let sidemenu = mainStoryboard.instantiateViewController(withIdentifier: "SideMenuBarVCID") as? SideMenuBarVC
                
                let vc = SWRevealViewController(rearViewController: sidemenu, frontViewController: navigation)
                
                self.present(vc!, animated: true, completion: nil)
                
            }
            else if indexPath.row == 2 {
                
                let myTicketsVC = mainStoryboard.instantiateViewController(withIdentifier: "MyTicketsViewControllerID") as! MyTicketsViewController
                
                let navigation: SampleNavigation = SampleNavigation(rootViewController: myTicketsVC)
                
                let sidemenu = mainStoryboard.instantiateViewController(withIdentifier: "SideMenuBarVCID") as? SideMenuBarVC
                
                let vc = SWRevealViewController(rearViewController: sidemenu, frontViewController: navigation)
                
                self.present(vc!, animated: true, completion: nil)
                
            }
            else if indexPath.row == 3 {
                
                let unassignedTicketsVC = mainStoryboard.instantiateViewController(withIdentifier: "UnAssignedTicketsID") as! UnAssignedTickets
                
                let navigation: SampleNavigation = SampleNavigation(rootViewController: unassignedTicketsVC)
                
                let sidemenu = mainStoryboard.instantiateViewController(withIdentifier: "SideMenuBarVCID") as? SideMenuBarVC
                
                let vc = SWRevealViewController(rearViewController: sidemenu, frontViewController: navigation)
                
                self.present(vc!, animated: true, completion: nil)
                
            }
            else if indexPath.row == 4 {
                
                let closedTicketsVC = mainStoryboard.instantiateViewController(withIdentifier: "ClosedTicketsID") as! ClosedTickets
                
                let navigation: SampleNavigation = SampleNavigation(rootViewController: closedTicketsVC)
                
                let sidemenu = mainStoryboard.instantiateViewController(withIdentifier: "SideMenuBarVCID") as? SideMenuBarVC
                
                let vc = SWRevealViewController(rearViewController: sidemenu, frontViewController: navigation)
                
                self.present(vc!, animated: true, completion: nil)
                
            }
            else if indexPath.row == 5 {
                
                let trashTicketsVC = mainStoryboard.instantiateViewController(withIdentifier: "TrashTicketsID") as! TrashTickets
                
                let navigation: SampleNavigation = SampleNavigation(rootViewController: trashTicketsVC)
                
                let sidemenu = mainStoryboard.instantiateViewController(withIdentifier: "SideMenuBarVCID") as? SideMenuBarVC
                
                let vc = SWRevealViewController(rearViewController: sidemenu, frontViewController: navigation)
                
                self.present(vc!, animated: true, completion: nil)
                
            }
            
            
        }
        else if indexPath.section == 1{
            
           if indexPath.row == 0{
                
            let userListVC = mainStoryboard.instantiateViewController(withIdentifier: "UsersListViewControllerID") as! UsersListViewController
            
            let navigation: SampleNavigation = SampleNavigation(rootViewController: userListVC)
            
            let sidemenu = mainStoryboard.instantiateViewController(withIdentifier: "SideMenuBarVCID") as? SideMenuBarVC
            
            let vc = SWRevealViewController(rearViewController: sidemenu, frontViewController: navigation)
            
            self.present(vc!, animated: true, completion: nil)
            
            }
            
        }
       
        else if indexPath.section == 2{
            
            if indexPath.row == 0{
                
                let aboutUsVC = mainStoryboard.instantiateViewController(withIdentifier: "AboutUsViewControllerID") as! AboutUsViewController
                
                let navigation: SampleNavigation = SampleNavigation(rootViewController: aboutUsVC)
                
                let sidemenu = mainStoryboard.instantiateViewController(withIdentifier: "SideMenuBarVCID") as? SideMenuBarVC
                
                let vc = SWRevealViewController(rearViewController: sidemenu, frontViewController: navigation)
                
                self.present(vc!, animated: true, completion: nil)
                
            }
            else if indexPath.row == 1{
                
                print("Logout Clicked")
                
                userDefaults.set("", forKey: "loginValue")
                userDefaults.synchronize()
                
                let loginVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewControllerID")
                
                self.present(loginVC, animated: true, completion: nil)
                
                
                //Showing Success Message
                var iconSpec = successSpec
                iconSpec.iconImage = UIImage(named: "SuccessMessageIcon")
                
                self.rControl.showMessage(
                    withSpec: iconSpec,
                    atPosition: .bottom, // .top // .bottom
                    title: " Faveo Helpdesk ",
                    body: "You've logged out, successfully...!",
                    viewController: self
                )
                ////Showing Success Message End
                
               
                
            }
            
        }

       
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44.0
    }
    
    func getDependeciesAPICall(){
        
        
        var getDependecyValuesUrl = userDefaults.string(forKey: "baseURL")
        getDependecyValuesUrl?.append("api/v1/helpdesk/dependency")
        
        let tokenValue = userDefaults.string(forKey:"token")
        // print("token=>",tokenValue!)
        
        requestGETURL(getDependecyValuesUrl!, params: ["token":tokenValue as AnyObject ],  success: { (data) in
            
            
            //  print("Dependency JSON is: ",data)
            
            let msg = data["message"].stringValue
            print("Message is: ",msg)
            
            if msg == "Token has expired"{
                
                tokenRefreshMethod()
                self.getDependeciesAPICall()
            }
            else if data["error"].exists(){
                
                showAlert(title: "OOPs...", message: "Too Many Attempts. Please try after sometime.", vc: self)
            }
            else{
                
                
                //Ticket Priority
                let ticketPriorityArray = data["result"]["priorities"].array
                for priorityValue in ticketPriorityArray!{
                    
                    let name = priorityValue["priority"].stringValue
                    let idValue = priorityValue["priority_id"].intValue
                    
                    self.prioritiesNamesArray.append(name)
                    self.prioritiesIdArray.append(idValue)
                }
                
                GlobalVariables.sharedManager.priorityNamesArray = self.prioritiesNamesArray
                GlobalVariables.sharedManager.priorityIdsArray = self.prioritiesIdArray
                
                //Help Topics
                let helpTopicArray = data["result"]["helptopics"].array
                for helpTopicsValue in helpTopicArray!{
                    
                    let topicName = helpTopicsValue["topic"].stringValue
                    let topicId = helpTopicsValue["id"].intValue
                    
                    self.helptopicsNamesArray.append(topicName)
                    self.helptopicsIdArray.append(topicId)
                }
                
                GlobalVariables.sharedManager.helpTopicNamesArray = self.helptopicsNamesArray
                GlobalVariables.sharedManager.helpTopicIdsArray =  self.helptopicsIdArray
                
                //Ticket Source
                let sourcesArray = data["result"]["sources"].array
                
                for sourceValue in sourcesArray!{
                    
                    let sourceName = sourceValue["name"].stringValue
                    let sourceId = sourceValue["id"].intValue
                    
                    self.ticketSourcesNamesArray.append(sourceName)
                    self.ticketSourcesIdArray.append(sourceId)
                    
                }
                
                GlobalVariables.sharedManager.sourceNamesArray = self.ticketSourcesNamesArray
                GlobalVariables.sharedManager.sourceIdsArray =  self.ticketSourcesIdArray
                
                //SLA
                let slasArray = data["result"]["sla"].array
                for slaValue in slasArray!{
                    
                    let slaName = slaValue["name"].stringValue
                    let slaId = slaValue["id"].intValue
                    
                    self.slaNamesArray.append(slaName)
                    self.slaIdsArray.append(slaId)
                    
                }
                GlobalVariables.sharedManager.slaNameArray = self.slaNamesArray
                GlobalVariables.sharedManager.slaIdArray = self.slaIdsArray
                
                
            /*  //Ticket Status
                let ticketStatusArray = data["result"]["status"].array
                
                // print(ticketStatusArray!)
                
                for status in ticketStatusArray!{
                    
                    /*    print(status) // it will print each status dictionary
                     //output
                     {
                     "id" : 2,
                     "name" : "Resolved"
                     }
                     
                     */
                    
                    
                    let statusName = status["name"].stringValue
                    //  let idValue = status["id"].intValue
                    
                    if statusName == "Open"{
                        
                        //  print("Open Status id : \(status["id"].intValue)")
                        GlobalVariables.sharedManager.openStatusId = status["id"].intValue
                    }
                    else if statusName == "Resolved"{
                        
                        //   print("Resolved Status id : \(status["id"].intValue)")
                        GlobalVariables.sharedManager.resolvedStatusId = status["id"].intValue
                    }
                    else if statusName == "Closed"{
                        
                        //   print("Closed Status id : \(status["id"].intValue)")
                        GlobalVariables.sharedManager.closedStatusId = status["id"].intValue
                    }
                    else if statusName == "Archived"{
                        
                        //   print("Archived Status id : \(status["id"].intValue)")
                        GlobalVariables.sharedManager.archievedStatusId = status["id"].intValue
                    }
                    else if statusName == "Deleted"{
                        
                        //   print("Deleted Status id : \(status["id"].intValue)")
                        GlobalVariables.sharedManager.deletedStatusId = status["id"].intValue
                    }
                    else if statusName == "Unverified"{
                        
                        //   print("Unverified Status id : \(status["id"].intValue)")
                        GlobalVariables.sharedManager.unverifiedStatusId = status["id"].intValue
                    }
                    else if statusName == "Request Approval"{
                        
                        //   print("Request Approval Status id : \(status["id"].intValue)")
                        GlobalVariables.sharedManager.requestForApprovalStatusId = status["id"].intValue
                    }
                    else{
                        //nothing
                    }
                    
                    //                    if status["Open"].stringValue == "Open"{
                    //
                    //                        print(status["name"].stringValue)
                    //                        print(status["count"].stringValue)
                    //                    }
                    
                    // print(self.nameArray)
                    
                    
                }
                
          */
                //Ticket counts
                let ticketsCountArray = data["result"]["tickets_count"].array
                
                for countValue in ticketsCountArray!{
                    
                    let countName = countValue["name"].stringValue
                    
                    //open tickets
                    
                    if countName == "Open"{
                        
                        GlobalVariables.sharedManager.openTicketsCount = countValue["count"].intValue
                        
                    }
                    else if countName == "Closed"{
                        
                        GlobalVariables.sharedManager.closedTicketsCount = countValue["count"].intValue
                        
                    }
                    else if countName == "Deleted"{
                        
                        GlobalVariables.sharedManager.deletedTicketsCount = countValue["count"].intValue
                        
                    }
                    else if countName == "unassigned"{
                        
                        GlobalVariables.sharedManager.unassignedTicketsCount = countValue["count"].intValue
                        
                    }
                    else if countName == "mytickets"{
                        
                        GlobalVariables.sharedManager.myTicketsCount = countValue["count"].intValue
                        
                    }
                    else{
                        
                        //
                    }
                    
                }
                
            }
            
        }) { (error) in
            
            print(error)
        }
        
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
        
        refreshControl1.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        refreshControl1.backgroundColor =  UIColor(red:0.46, green:0.8, blue:1.0, alpha:1.0)
        
        refreshControl1.attributedTitle = refreshing
        refreshControl1.tintColor = UIColor.white
        
    }
    
    
    @objc private func refreshTableView() {
        
        DispatchQueue.main.async {
            
            print("Refresh TableView Called")
            self.showLoggedUserProfileDetails()
            
        }
    }
    
    
}
