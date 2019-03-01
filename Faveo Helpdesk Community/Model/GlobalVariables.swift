//
//  GlobalVariables.swift
//  Faveo Helpdesk Community
//
//  Created by Mallikarjun on 06/01/19.
//  Copyright © 2019 Ladybird Web Solution. All rights reserved.
//

import Foundation

class GlobalVariables {
    
    var  UrlText:String?
    // These are the properties you can store in your singleton
    private var myName: String = "bob"
    
    var firstName:String?
    var lastName:String?
    var ticketNumber:String?
    var userName:String?
    var ticketStatus:String?
    var ticketId:Int?
    
    var userNameFromUserList:String?
    var firstNameFromUserList:String?
    var lastNameFromUserList:String?
    var emailFromUserList:String?
    var profilePictureFromUserList:URL?
    var mobileNumberFromUserList:Int?
    var mobileCodeFromUserList:Int?
    var userIdFromUserList:Int?
    var userStateFromUserList:Int?
    
    
    var openTicketsCount:Int?
    var closedTicketsCount:Int?
    var deletedTicketsCount:Int?
    var unassignedTicketsCount:Int?
    var myTicketsCount:Int?
    
    var openStatusId:Int?
    var closedStatusId:Int?
    var deletedStatusId:Int?
    var resolvedStatusId:Int?
    var requestForCloseStatusId:Int?
    var spamStatusId:Int?
    var archievedStatusId:Int?
    var unverifiedStatusId:Int?
    var requestForApprovalStatusId:Int?
    
    //This variable is used to know that from which VC it came to edit ticket VC and where it has to navigate back after editing/updating details. Values - inboxTickets, myTickets, unassignedTickets, closedTickers, trashTickets
     var fromVC:String?
    
    
    var dependencyDataDictionary:[String:Any]?
    
//    var prioritiesArray:[Any]?
//    var helptopicsArray:[Any]?
//    var sourceArray:[Any]?
//    var slaArray:[Any]?
//    var statusArray:[Any]?
    

    //Priority
    var priorityNamesArray:[String]?
    var priorityIdsArray:[Int]?
    //HelpTopics
    var helpTopicNamesArray:[String]?
    var helpTopicIdsArray:[Int]?
    //Ticket Source
    var sourceNamesArray:[String]?
    var sourceIdsArray:[Int]?
    //SLA
    var slaNameArray:[String]?
    var slaIdArray:[Int]?
    
    
    // Here is how you would get to it without there being a global collision of variables.
    // , or in other words, it is a globally accessable parameter that is specific to the
    // class.
    class var sharedManager: GlobalVariables {
        struct Static {
            static let instance = GlobalVariables()
        }
        return Static.instance
    }
}


