//
//  UsersListViewController.swift
//  Faveo Helpdesk Community
//
//  Created by Mallikarjun on 17/01/19.
//  Copyright © 2019 Ladybird Web Solution. All rights reserved.
//

import UIKit
import RMessage

class UsersDataList{
    
    let firstName:String
    let lastName:String
    let userName:String
    let userEmail:String
    let userProfilePicture:URL
    let userId:Int
    let mobileNumber:Int
    let mobileCode:Int
    let activeOrInactive:Int
    
    init(firstname:String, lastname:String, username:String, useremail:String, userprofilepicture:URL, userid:Int, mobilenumber:Int, mobilecode:Int,activeorinactive:Int ) {
        
        self.firstName = firstname
        self.lastName = lastname
        self.userName = username
        self.userEmail = useremail
        self.userProfilePicture = userprofilepicture
        self.userId = userid
        self.mobileNumber = mobilenumber
        self.mobileCode = mobilecode
        self.activeOrInactive = activeorinactive
    }
    
}


class UsersListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,RMControllerDelegate {
  
   
    
    
    @IBOutlet weak var skeltonView: UIView!
    
    
    @IBOutlet weak var skeltonImage1: UIImageView!
    
    @IBOutlet weak var skeltonImage2: UIImageView!
    
    @IBOutlet weak var skeltonImage3: UIImageView!
    
    @IBOutlet weak var skeltonImage4: UIImageView!
    
    @IBOutlet weak var skeltonImage5: UIImageView!
    
    
    
    
    
    
    
    

    var selectedPath:IndexPath?
    var selectedTicketId:String?
    var selectedIdCount:Int?
    
    
    var sampleArray:Array<String> = Array<String>()
    var dataArray = [UsersDataList]()
    var totalDataArray = [UsersDataList]()
    var totalDataArray2 = [UsersDataList]()
    
    var nextPageURL:String?
    var currentPage:Int?
    var totalTickets:Int?
    var totalPages:Int?

    
    let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var sampleTableView: UITableView!
    
    @IBOutlet weak var sideMenuButton: UIBarButtonItem!
    
    //RMessage
    private let rControl = RMController()
    
    //create an instance of the UIRefreshControl class
    private let refreshControl = UIRefreshControl()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        sampleTableView.isHidden = true
        skeltonImage1.loadGif(name: "skeltonGif")
        skeltonImage2.loadGif(name: "skeltonGif")
        skeltonImage3.loadGif(name: "skeltonGif")
        skeltonImage4.loadGif(name: "skeltonGif")
        skeltonImage5.loadGif(name: "skeltonGif")
        
        // Do any additional setup after loading the view.
        setUpSideMenuBar()
        
        //tableViewcell
        sampleTableView.register(UINib(nibName: "ClientListTableViewCell", bundle: nil), forCellReuseIdentifier: "ClientListTableViewCellID")
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            sampleTableView.refreshControl = refreshControl
        } else {
            sampleTableView.addSubview(refreshControl)
        }
        
        self.sampleTableView.tableFooterView = UIView()
        
        // Configure Refresh Control
        self.configureRefreshControl()
        
        //RMessage
        rControl.presentationViewController = self
        rControl.delegate = self

        
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
        // to set black background color mask for Progress view
        
       
        getUserLists()
        
        }
        
    }
    
    
    //setting up side-menu bar
    func setUpSideMenuBar(){
        
        if revealViewController() != nil{
            
            sideMenuButton.target = revealViewController()
            sideMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            revealViewController()?.rearViewRevealWidth = 320 //320
            // revealViewController()?.rightViewRevealWidth = 160
            
            view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        }
        
    }// End of setUpSideMenuBar method
    
        
    func getUserLists() {
      
        var getUsersListURL = userDefaults.string(forKey: "baseURL")
        getUsersListURL?.append("api/v1/helpdesk/customers-custom")
        
        let tokenValue = userDefaults.string(forKey:"token")
        // print("token=>",tokenValue!)
        
        requestGETURL(getUsersListURL!, params: ["token":tokenValue as AnyObject ],  success: { (data) in
            
            
           // print("Users JSON is: ",data)
            
            let msg = data["message"].stringValue
            print("Message is: ",msg)
            
            if msg == "Token has expired"{
                
                tokenRefreshMethod()
                self.getUserLists()
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
                    
                    let userId1 = dataList["id"].intValue
                    let userName1 = dataList["email"].stringValue
                    let userFirstName1 = dataList["first_name"].stringValue
                    let userLastName1 = dataList["last_name"].stringValue
                    let userEmail1 = dataList["email"].stringValue
                    let userProfilePicture1 = dataList["profile_pic"].url
                    let mobileNumber = dataList["mobile"].intValue
                    let code = dataList["mobile_code"].intValue
                    let activeValueOfUser = dataList["active"].intValue
                    
                    var userFullName:String
                    
                    if userFirstName1 == "" && userLastName1 == ""{
                        
                        if userName1 != ""{
                            
                            userFullName = userName1
                        }
                        else{
                            userFullName = "Not Available"
                        }
                       
                    }
                    else{
                        userFullName = "\(userFirstName1)\(" ") \(userLastName1)"
                    }
                    
                    
                    self.dataArray.append(UsersDataList(firstname: userFullName, lastname: userLastName1, username: userName1, useremail: userEmail1, userprofilepicture: userProfilePicture1!, userid: userId1, mobilenumber: mobileNumber, mobilecode: code, activeorinactive: activeValueOfUser))
                    
                    self.totalDataArray = self.dataArray
                    
                    dataIterator = dataIterator + 1
                    
                    
                } // End - for dataList
                
                
                DispatchQueue.main.async {
                    self.sampleTableView.reloadData()
                    self.refreshControl.endRefreshing()
                    self.sampleTableView.isHidden = false
                }
 
                
                
            } // End of - else of if msg
            
 
        }) { (error) in
            
            //Example: After timeout error - The request timed out.
            print("Error From Getting Users List API Call: \(error.localizedDescription)")
            
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
        
        if totalDataArray.count < 1{
            
            let emptyDataImage = UIImage(named: "AppIcon")
            let emptyDataImageView = UIImageView(image: emptyDataImage)
            
            emptyDataImageView.loadGif(name: "Nodata")
            emptyDataImageView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height)
            tableView.backgroundView = emptyDataImageView
            
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
        
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
        cell.layer.transform = rotationTransform
        
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseOut, animations: {
            cell.layer.transform = CATransform3DIdentity
            
        })
        
        cell.selectionStyle = .none
        
        if indexPath.row == totalDataArray.count - 1 {
            print("nextURL is: \(nextPageURL ?? "null")")
            
            if nextPageURL != nil && !nextPageURL!.isEmpty {
                
                // loadMore()
                getNextPageUserList(nextPageUrl: nextPageURL!)
                print("There are more users")
            }
            else {
                print("There is no more users")
                
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
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
            
       let cell = tableView.dequeueReusableCell(withIdentifier: "ClientListTableViewCellID", for: indexPath) as! ClientListTableViewCell
        
        cell.userName.text = totalDataArray[indexPath.row].firstName
        cell.userEmail.text = totalDataArray[indexPath.row].userEmail
       // cell.userMobileNumber.text = totalDataArray[indexPath.row].mobileNumber
        
        let mobileNumber:Int = totalDataArray[indexPath.row].mobileNumber
        let mobileCode:Int = totalDataArray[indexPath.row].mobileCode
        
        // MobileNumber
        
        if mobileNumber  > 0 {
            
            let mobile = String(mobileNumber)
            let code = String(mobileCode)
            
            if mobileNumber  > 0 && mobileCode > 0{
                
                cell.userMobileNumber.text = "+\(code) \((mobile))"
            }
            else{
                cell.userMobileNumber.text = "\(mobile)"
            }
            
        }
        else{
            cell.userMobileNumber.text = "Not Available"
        }
        
        
        //username
        let name = totalDataArray[indexPath.row].firstName
        
        //Profile Image
        let imageUrl = totalDataArray[indexPath.row].userProfilePicture
        
        if imageUrl.absoluteString.hasSuffix("system.png") || imageUrl.absoluteString.hasSuffix(".jpg") || imageUrl.absoluteString.hasSuffix(".jpeg") || imageUrl.absoluteString.hasSuffix(".png"){
            
            cell.setUserProfileimage(imageUrl: imageUrl)
        }
        else{
            
            cell.userProfilePicture.setImage(string: name, color: UIColor.colorHash(name: name), circular: true)
        }
        
        return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
  
      GlobalVariables.sharedManager.userNameFromUserList = totalDataArray[indexPath.row].userName
      GlobalVariables.sharedManager.firstNameFromUserList =  totalDataArray[indexPath.row].firstName
      //GlobalVariables.sharedManager.lastNameFromUserList =
      GlobalVariables.sharedManager.emailFromUserList = totalDataArray[indexPath.row].userEmail
      GlobalVariables.sharedManager.profilePictureFromUserList = totalDataArray[indexPath.row].userProfilePicture
      GlobalVariables.sharedManager.mobileNumberFromUserList =  totalDataArray[indexPath.row].mobileNumber
      GlobalVariables.sharedManager.mobileCodeFromUserList = totalDataArray[indexPath.row].mobileCode
      GlobalVariables.sharedManager.userIdFromUserList = totalDataArray[indexPath.row].userId
      GlobalVariables.sharedManager.userStateFromUserList = totalDataArray[indexPath.row].activeOrInactive
        
      let detailView = self.storyboard?.instantiateViewController(withIdentifier: "UsersDetailsViewControllerID") as! UsersDetailsViewController
        
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
    
    func getNextPageUserList(nextPageUrl:String){
        
        let tokenValue = userDefaults.string(forKey:"token")
        print("token=>",tokenValue!)
        
        var nextURLString = nextPageUrl
        nextURLString.append("&token=")
        nextURLString.append(tokenValue!)
        
        print("Next Page URL is: \(nextURLString)")

        
        requestGETURL(nextURLString, params: nil,  success: { (data) in
            
        //    print("Next Users JSON is: ",data)
            
            let msg = data["message"].stringValue
            print("Message is: ",msg)
            
            if msg == "Token has expired"{
                
                tokenRefreshMethod()
                self.getNextPageUserList(nextPageUrl: nextPageUrl)
            }
            else{
                
                self.nextPageURL = data["next_page_url"].stringValue
                self.currentPage = data["current_page"].intValue
                self.totalTickets = data["total"].intValue
                self.totalPages = data["last_page"].intValue
                
                var dataIterator = 0
                
                for dataList in data["data"].arrayValue{
                    
                    let userId1 = dataList["id"].intValue
                    let userName1 = dataList["email"].stringValue
                    let userFirstName1 = dataList["first_name"].stringValue
                    let userLastName1 = dataList["last_name"].stringValue
                    let userEmail1 = dataList["email"].stringValue
                    let userProfilePicture1 = dataList["profile_pic"].url
                    let mobileNumber = dataList["mobile"].intValue
                    let code = dataList["mobile_code"].intValue
                    let activeValueOfUser = dataList["active"].intValue
                    
                    var userFullName:String
                    
                    if userFirstName1 == "" && userLastName1 == ""{
                        
                        if userName1 != ""{
                            
                            userFullName = userName1
                        }
                        else{
                            userFullName = "Not Available"
                        }
                        
                    }
                    else{
                        userFullName = "\(userFirstName1)\(" ") \(userLastName1)"
                    }
                    
                    
                    self.dataArray.append(UsersDataList(firstname: userFullName, lastname: userLastName1, username: userName1, useremail: userEmail1, userprofilepicture: userProfilePicture1!, userid: userId1, mobilenumber: mobileNumber, mobilecode: code, activeorinactive: activeValueOfUser))
                    
                    self.totalDataArray = self.dataArray
                    
                    dataIterator = dataIterator + 1
                    
                    
                } // End - for dataList
                
                
                DispatchQueue.main.async {
                    self.sampleTableView.reloadData()
                    self.refreshControl.endRefreshing()
                    self.sampleTableView.isHidden = false

                }
                
                
                
            } // End of - else of if msg
            
            
        }) { (error) in
            
            //Example: After timeout error - The request timed out.
            print("Error From Getting Users List API Call: \(error.localizedDescription)")
            
            showAlert(title: "Faveo Heldesk", message: error.localizedDescription, vc: self)
            self.sampleTableView.isHidden = false

        }
        

    }
    
    @objc private func refreshTableView() {
        
        DispatchQueue.main.async {
            
            print("Refresh TableView Method Called")
            self.getUserLists()
            
        }
    }

}
