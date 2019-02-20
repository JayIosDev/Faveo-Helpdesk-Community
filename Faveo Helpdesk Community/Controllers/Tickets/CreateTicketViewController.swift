//
//  CreateTicketViewController.swift
//  Faveo Helpdesk Community
//
//  Created by Mallikarjun on 15/01/19.
//  Copyright © 2019 Ladybird Web Solution. All rights reserved.
//

import UIKit
import SVProgressHUD
import ActionSheetPicker_3_0
import CountryPickerView
import RMessage

class CreateTicketViewController: UITableViewController,UITextFieldDelegate,RMControllerDelegate,UITextViewDelegate {

    
    // RMessage
     private let rControl = RMController()
    
    @IBOutlet weak var menuButtonItem: UIBarButtonItem!
    
    @IBOutlet var sampleTableView: UITableView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var subjectTextView: UITextView!
    @IBOutlet weak var messageTextView: UITextView!
    
    
    @IBOutlet weak var priorityTextField: UITextField!
    @IBOutlet weak var helptopicTextField: UITextField!
    @IBOutlet weak var slaTextField: UITextField!
    
    @IBOutlet weak var submitButtonOutlet: UIButton!
    
    
    @IBOutlet weak var mobileCode: CountryPickerView!
    
    
    @IBOutlet weak var mobileNumber: UITextField!
    
    var selectedPriorityId:Int?
    var selectedHelpTopicId:Int?
    var selectedSLAId:Int?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // Do any additional setup after loading the view.
        setUpSideMenuBar()
        
        // RMessage
        rControl.presentationViewController = self
        rControl.delegate = self

       self.priorityTextField.delegate = self
       self.helptopicTextField.delegate = self
       self.slaTextField.delegate = self
        
        // to set black background color mask for Progress view
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        
        
    }
    
    //setting up side-menu bar
    func setUpSideMenuBar(){
        
        if revealViewController() != nil{
            
            menuButtonItem.target = revealViewController()
            menuButtonItem.action = #selector(SWRevealViewController.revealToggle(_:))
            
            revealViewController()?.rearViewRevealWidth = 320 //320
            // revealViewController()?.rightViewRevealWidth = 160
            
            view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        }
        
    }// End of setUpSideMenuBar method
    
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
            self.helptopicTextField.text = index as? String
            
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
    

    
    @IBAction func SubmitButtonClicked(_ sender: Any) {

       
        SVProgressHUD.show(withStatus: "Please wait...")
        
        print("clicked")
        
        if emailTextField.text == "" || firstNameTextField.text == "" || subjectTextView.text == "" && messageTextView.text == "" || priorityTextField.text == "" || helptopicTextField.text == "" || slaTextField.text == "" || mobileNumber.text == ""{
            
            SVProgressHUD.dismiss()
            //show alert message - Please fill mandatory fields.
             print(" Enter all required fields")
        }
//        else if emailTextField.text != ""{
//
//           let result = emailValidation(emailTextField.text)
//
//            if result == true{
//
//                print(" valid email")
//
//            }
//            else{
//
//                SVProgressHUD.dismiss()
//                //Please eneter valid email
//                print("please enter valid email")
//            }
//
//        }
        else if (firstNameTextField!.text?.count)! < 2 {
               SVProgressHUD.dismiss()
               print("name should be more 2 or more")
        }
        else{
            
            //call creat ticket api
             createTicketAPICall()
        }
        
        
    }
    
    
    func createTicketAPICall() {
        
        //Priority Value
        let priorityNamesArray2 = GlobalVariables.sharedManager.priorityNamesArray
        
        selectedPriorityId = NSNumber(value: 1 + priorityNamesArray2!.index(of: priorityTextField.text!)!) as? Int
        //  print("Selected Priority : %@ Id is : \(selectedPriorityId!)",priorityTextField.text!)
        
        //HelpTopic Value
        let helpTopicArray2 = GlobalVariables.sharedManager.helpTopicNamesArray
        
        selectedHelpTopicId = NSNumber(value: 1 + helpTopicArray2!.index(of: helptopicTextField.text!)!) as? Int
        //  print("Selected HelpTopic : %@ Id is : \(selectedHelpTopicId!)",helpTopicTextField.text!)
        
        //SLA Value
        let slaArray2 = GlobalVariables.sharedManager.slaNameArray
        
        selectedSLAId = NSNumber(value: 1 + slaArray2!.index(of: slaTextField.text!)!) as? Int
        //   print("Selected SLA : %@ Id is : \(selectedSLAId!)",slaTextField.text!)
        
        let countryCode = mobileCode.selectedCountry.phoneCode
       // print(countryCode)
        
        
        let userDefaults = UserDefaults.standard
        
        var url:String = UserDefaults.standard.string(forKey: "baseURL") ?? ""
        url.append("api/v1/helpdesk/create")
        
        let tokenValue = userDefaults.string(forKey:"token")
        
        let emailValue = emailTextField.text
        let firstName = firstNameTextField.text
        let lastName = lastNameTextField.text
        let ticketSubject = subjectTextView.text
        let ticketMessage = messageTextView.text
        let mobilenumber = mobileNumber.text
        
        requestPOSTURL(url, params: ["token":tokenValue as AnyObject,
                                     "email":emailValue as AnyObject,
                                     "first_name":firstName as AnyObject,
                                     "last_name":lastName as AnyObject,
                                     "priority":selectedPriorityId as AnyObject,
                                     "helptopic":selectedHelpTopicId as AnyObject,
                                     "sla":selectedSLAId as AnyObject,
                                     "subject":ticketSubject as AnyObject,
                                     "phone":mobilenumber as AnyObject,
                                     "code":countryCode as AnyObject,
                                     "body":ticketMessage as AnyObject,], success: { (data) in
                                        
                                        
                                        print("JSON is: ",data)
                                        
                                        let msg = data["message"].stringValue
                                        print("Message is: ",msg)
                                        
                                        if msg == "Token has expired"{
                                            
                                            tokenRefreshMethod()
                                            self.createTicketAPICall()
                                        }
                                        else{
                                            
                                          
                                            let msg = data["response"]["message"].stringValue
                                            
                                            if msg == "Ticket created successfully!"{
                                                
                                                print("I am in print - Ticket is Created")
                                                
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
                                                    title: "Success",
                                                    body: "Ticket is created successfully..!",
                                                    viewController: navigationController
                                                )
                                                ////Showing Success Message End
                                                
                                                let inboxVC = self.storyboard!.instantiateViewController(withIdentifier: "InboxViewControllerID") as! InboxViewController
                                                
                                               self.navigationController?.pushViewController(inboxVC, animated: true)
                                                
                                                
                                            }
                                            else{
                                                
                                                showAlert(title: "Error", message: "Something went wrong. Please try again later.", vc: self)
                                                SVProgressHUD.dismiss()
                                                
                                            }
                                            
                                            
                                        }
                                        
        }) { (error) in
            
            //Example: After timeout error - The request timed out.
            print("Error From Token Refresh Method: \(error.localizedDescription)")
            
            showAlert(title: "Faveo Heldesk", message: error.localizedDescription, vc: self)
            SVProgressHUD.dismiss()
        }
        
        
    }
    
    
    
    //Asks the delegate if editing should begin in the specified text field.
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == priorityTextField || textField == helptopicTextField || textField == slaTextField{
            return false; //do not show keyboard nor cursor
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if textField == firstNameTextField || textField == lastNameTextField{
        
           let aSet = NSCharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.-_").inverted
           let compSepByCharInSet = string.components(separatedBy: aSet)
           let numberFiltered = compSepByCharInSet.joined(separator: "")
           
            return string == numberFiltered
        }
        else if textField == emailTextField{
            
            let aSet = NSCharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890@-_.").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            
            return string == numberFiltered
        }
        else if textField == mobileNumber{
            
            
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            
            return string == numberFiltered
            
            
        }
        
        return true
    }
    

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if textView == subjectTextView || textView == messageTextView {
            
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
