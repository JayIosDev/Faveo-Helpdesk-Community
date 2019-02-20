//
//  Utils.swift
//  Faveo Helpdesk Community
//
//  Created by Mallikarjun on 05/01/19.
//  Copyright © 2019 Ladybird Web Solution. All rights reserved.
//

import Foundation

public  func showAlert(title:String, message:String, vc: UIViewController) {
    
           let alertView1 = UIAlertController(title: title, message: message, preferredStyle: .alert)
           alertView1.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
           vc.present(alertView1,animated: true,completion: nil)
         }

public func showLogoutAlert(title:String, message:String, vc:UIViewController){
    
    // Create the alert controller
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    // Create the actions
    let okAction = UIAlertAction(title: "Logout", style: .default) {
        UIAlertAction in
        print("Clicked on Logout Button - UIAlertView")
        logoutMethod(vc: vc)
    }
    alertController.addAction(okAction)

    // Present the controller
    vc.present(alertController,animated: true,completion: nil)
}

public func logoutMethod(vc:UIViewController) {
    
    UserDefaults.standard.set("", forKey: "loginValue")
    UserDefaults.standard.synchronize()
    
    let loginVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewControllerID")
    
    vc.present(loginVC, animated: true, completion: nil)
    
}

public func emailValidation(_ strEmail: String?) -> Bool {
    
    let emailRegex = "[A-Z0-9a-z._%+]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    let myStringMatchesRegEx: Bool = emailTest.evaluate(with: strEmail)
    
    return myStringMatchesRegEx
}

public func compareDates(strDate: String?) -> Bool {
    
       let dtFormat = DateFormatter()
       dtFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
       if let time = NSTimeZone(abbreviation: "UTC") {
           dtFormat.timeZone = time as TimeZone
       }
    
       let date1: Date? = dtFormat.date(from: strDate ?? "")
    
       let todayDate = Date() //Get todays date
       let dateFormatter = DateFormatter() // here we create NSDateFormatter object for change the Format of date.
       dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
       let date2: Date? = dateFormatter.date(from: dateFormatter.string(from: todayDate))
    
    
        if date1?.compare(date2!) == .orderedDescending {
               print("date1 is later than date2")
               return false
        } else if date1?.compare(date2!) == .orderedAscending {
               print("date1 is earlier than date2")
               return true
        } else {
               print("dates are the same")
               return false
           }
    
    
   }

public func getLocalDateTimeFromUTC(strDate: String?) -> String? {

    // create dateFormatter with UTC time format
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
    let date = dateFormatter.date(from: strDate!)// create   date from string
   // print("Date from Utils Class is")
    //print(date as Any)
    
    // change to a readable time format and change to local time zone
    dateFormatter.dateFormat = "EEE, MMM d, yyyy - h:mm a"
    dateFormatter.timeZone = NSTimeZone.local
    let timeStamp = dateFormatter.string(from: date!)
   //print("I am in timestamp")
    //print(timeStamp)
    
    return timeAgoSince(dateFormatter.date(from:timeStamp)!)
   // print(timeAgoSince(dateFormatter.date(from:timeStamp)!))
    
}

public func timeAgoSince(_ date: Date) -> String {
    
    let calendar = Calendar.current
    let now = Date()
    let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
    let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now, options: [])
    
    if let year = components.year, year >= 2 {
        return "\(year) years ago"
    }
    
    if let year = components.year, year >= 1 {
        return "Last year"
    }
    
    if let month = components.month, month >= 2 {
        return "\(month) months ago"
    }
    
    if let month = components.month, month >= 1 {
        return "Last month"
    }
    
    if let week = components.weekOfYear, week >= 2 {
        return "\(week) weeks ago"
    }
    
    if let week = components.weekOfYear, week >= 1 {
        return "Last week"
    }
    
    if let day = components.day, day >= 2 {
        return "\(day) days ago"
    }
    
    if let day = components.day, day >= 1 {
        return "Yesterday"
    }
    
    if let hour = components.hour, hour >= 2 {
        return "\(hour) hours ago"
    }
    
    if let hour = components.hour, hour >= 1 {
        return "An hour ago"
    }
    
    if let minute = components.minute, minute >= 2 {
        return "\(minute) minutes ago"
    }
    
    if let minute = components.minute, minute >= 1 {
        return "A minute ago"
    }
    
    if let second = components.second, second >= 3 {
        return "\(second) seconds ago"
    }
    
    return "Just now"
    
}
