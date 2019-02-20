//
//  LoginViewController.swift
//  Faveo Helpdesk Community
//
//  Created by Mallikarjun on 05/01/19.
//  Copyright © 2019 Ladybird Web Solution. All rights reserved.
//

import UIKit
import SVProgressHUD
import RMessage

class LoginViewController: UIViewController, UITextFieldDelegate,RMControllerDelegate {

    
    @IBOutlet weak var urlView: UIView!
   
    @IBOutlet weak var loginView: UIView!
 
    @IBOutlet weak var urlTextField: UITextField!
    
    @IBOutlet weak var userNameTextField: UITextField!
  
    @IBOutlet weak var passwordTextField: UITextField!
    
    let userDefaults = UserDefaults.standard
    
    //RMessage
     private let rControl = RMController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
        //RMessage
        rControl.presentationViewController = self
        rControl.delegate = self

        
        loginView.isHidden = true
        
        // to set black background color mask for Progress view
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        urlTextField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == urlTextField{
            
            urlTextField.resignFirstResponder()
            
           // print("Clicked on GO button on KeyBoard")
            SVProgressHUD.show(withStatus: "Validating URL")
            
            urlValidationAPIMethodCall()
        }
        
        textField.resignFirstResponder()
        
        return true
    }
    
    @IBAction func urlNextButtonClicked(_ sender: Any) {
        
        SVProgressHUD.show(withStatus: "Validating URL")
        
        urlValidationAPIMethodCall()
        
    }
    
    
    func urlValidationAPIMethodCall()  {
      
        if urlTextField.text == "" {
            
            showAlert(title: "Faveo Helpdesk", message: "Please Enter Your Helpdesk URL", vc: self)
            SVProgressHUD.dismiss()
            
        }
        else{
            
            urlTextField.resignFirstResponder()
            
            var enteredURL:String = urlTextField.text!
            enteredURL.append("/api/v1/helpdesk/url")
            
            
            requestGETURL(enteredURL, params: ["url":urlTextField.text as AnyObject],  success: { (data) in
                
                SVProgressHUD.dismiss()
                print("JSON is: ",data) // GOT JSON HERE
                
                
                //check the json contains result object
                if data["result"].exists() {
                    
                    let msg = data["result"].stringValue
                    print("Message is: ",msg)
                    
                    if msg == "{\"status\":\"success\"}"{
                        
                        var baseURL:String = self.urlTextField.text!
                        baseURL.append("/")
                        
                        self.userDefaults.set(baseURL, forKey: "baseURL")
                        self.userDefaults.synchronize()
                        
                        self.urlView.isHidden = true
                        self.loginView.isHidden = false
                        
                        self.sideMenuTransition(views: self.loginView)
                        
                        var iconSpec = successSpec
                        iconSpec.iconImage = UIImage(named: "SuccessMessageIcon")
                        
                        self.rControl.showMessage(
                            withSpec: iconSpec,
                            atPosition: .top, // .top // .bottom
                            title: "Success",
                            body: "URL is verified successfully.",
                            viewController: self
                         )
                    }
                    
                }//check the json contains message object
                else if data["message"].exists() {
                    
                    let msg = data["message"].stringValue
                    print("Message is: ",msg)
                    
                    if msg == "API disabled"{
                        
                        showAlert(title: "Faveo Helpdesk", message: "API option is disabled in your Helpdesk, please enable it from Admin panel.", vc: self)
                    }
                    
                    
                }
                else{
                    
                    //something went wrong
                    showAlert(title: "OOPs...", message:"Something went wrong, please try again later." , vc: self)
                    SVProgressHUD.dismiss()
                }
                
                
                
            }) { (error) in
                
                print("Error 111 is :\(error.localizedDescription) ")
                showAlert(title: "Error", message:error.localizedDescription , vc: self)
                SVProgressHUD.dismiss()
            }
            
        }

        
    }
    
  
    
 //showing moving animation - Hiding URL view and showing Login View
    func sideMenuTransition (views:UIView) {
        
        let transition = CATransition()
        transition.duration = 0.5
        
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        
        views.layer .add(transition, forKey: nil)
        
    }
    
    
    
    @IBAction func logginButtonClicked(_ sender: Any) {
       
        SVProgressHUD.show(withStatus: "Please wait...")
        
        
        if  userNameTextField.text == "" && passwordTextField.text == "" {
            
            showAlert(title: "Faveo Helpdesk", message: "Please Enter Username & Password.", vc: self)
            SVProgressHUD.dismiss()
            
        }
        else if  userNameTextField.text == ""{
            showAlert(title: "Faveo Helpdesk", message: "Please Enter Username.", vc: self)
            SVProgressHUD.dismiss()
        }
        else if  passwordTextField.text == ""{
            showAlert(title: "Faveo Helpdesk", message: "Please Enter Password.", vc: self)
            SVProgressHUD.dismiss()
        }
        else{
            
            authenticationAPICalled()
        }
        
       
        
    }
    
    
    func authenticationAPICalled() {
        
        var url = UserDefaults.standard.string(forKey: "baseURL")
        
        url?.append("api/v1/authenticate")
        
        
        requestPOSTURL(url!, params: ["username":userNameTextField.text as AnyObject,
                                     "password":passwordTextField.text as AnyObject], success: { (data) in
                                        
            
         //   print("JSON is: ",data)
            
            if data["error"].exists() {
               // failure case
                
                let msg = data["error"].stringValue
                print("Message is: ",msg)
                
                if msg == "invalid_credentials"{
                    
                    showAlert(title: "Faveo Helpdesk", message: "Please enter valid username and password.", vc: self)
                }
                
                SVProgressHUD.dismiss()
            }
            else if data["token"].exists() && data["user_id"].exists(){
               //success case
                
                let userRole  =  data["user_id"]["role"].stringValue
                
                if userRole == "user" {
                
                   showAlert(title: "Faveo Helpdesk", message: "Invalid entry for user. This app is used by Agent and Admin only.", vc: self)
                   SVProgressHUD.dismiss()
                }
                else{
                    
                    let userIdValue = data["user_id"]["id"].intValue
                    self.userDefaults.set(userIdValue, forKey: "userId")
                    
                    var firstName =  data["user_id"]["first_name"].stringValue
                    let lastName  =  data["user_id"]["last_name"].stringValue
                    firstName.append(" ")
                    firstName.append(lastName)
                    
                    let email     =  data["user_id"]["email"].stringValue
                    let profilePicture =  data["user_id"]["profile_pic"].stringValue
                    let tokenValue = data["token"].stringValue
                    
                    self.userDefaults.set(firstName, forKey: "userFullName")
                    self.userDefaults.set(email, forKey: "userEmail")
                    self.userDefaults.set(profilePicture, forKey: "userProfilePic")
                    self.userDefaults.set(tokenValue, forKey: "token")
                    
                    self.userDefaults.set(self.userNameTextField.text, forKey: "userNameValue")
                    self.userDefaults.set(self.passwordTextField.text, forKey: "passwordValue")
                    
                    self.userDefaults.set("LoggedIn", forKey: "loginValue")
                    self.userDefaults.synchronize()
                    
                    
                    
                    
                     let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                     
                     let inboxVC = mainStoryboard.instantiateViewController(withIdentifier: "InboxViewControllerID") as! InboxViewController
                     
                     let navigation: SampleNavigation = SampleNavigation(rootViewController: inboxVC)
                     
                     let sidemenu = mainStoryboard.instantiateViewController(withIdentifier: "SideMenuBarVCID") as? SideMenuBarVC
                     
                     let vc = SWRevealViewController(rearViewController: sidemenu, frontViewController: navigation)
                    
                    //Showing Success Message
                    var iconSpec = successSpec
                    iconSpec.iconImage = UIImage(named: "SuccessMessageIcon")
                    
                    self.rControl.showMessage(
                        withSpec: iconSpec,
                        atPosition: .navBarOverlay, // .top // .bottom
                        title: "Welcome.",
                        body: "You have logged in successfully.",
                        viewController: navigation
                    )
                    ////Showing Success Message End
                    
                     self.present(vc!, animated: true)
                    
                }
                
            
             }
            else{
                //unknown case
                showAlert(title: "Faveo Helpdesk", message: "Something went Wrong. Please try again later.", vc: self)
                SVProgressHUD.dismiss()
             }
                                        
                                        
        }) { (error) in
            print(error)
        }
        
        
    }
    


}
