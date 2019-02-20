//
//  Faveo_Helpdesk_CommunityUITests.swift
//  Faveo Helpdesk CommunityUITests
//
//  Created by Mallikarjun on 05/01/19.
//  Copyright © 2019 Ladybird Web Solution. All rights reserved.
//

import XCTest

class Faveo_Helpdesk_CommunityUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
   /*
       Execution Flow for Reply Ticket.
       Open App -> Load Inbox Tickets -> Click on any row in tableView -> Click on floating point button -> Click on Reply Ticket Button -> Add an reply message into the text field -> click on add reply button
     
    */
    
    func testTicketReply() {
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Hey"].tap()
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.children(matching: .other).element(boundBy: 1).tap()
        element.children(matching: .other).element(boundBy: 2).children(matching: .other).element(boundBy: 0).tap()
        
        let textView = tablesQuery.cells.containing(.staticText, identifier:"Reply Content*").children(matching: .textView).element
        textView.tap()
        textView.typeText("This is the sample message")
        
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["SUBMIT"]/*[[".cells.buttons[\"SUBMIT\"]",".buttons[\"SUBMIT\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
      
    }
    
    /*
     Execution Flow for Adding internal Note.
     Open App -> Load Inbox Tickets -> Click on any row in tableView -> Click on floating point button -> Click on Internal Note Button -> Add an note into the text field -> click on add note button
     
     */
    func testAddInternalNote() {
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Hey"].tap()
        
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.children(matching: .other).element(boundBy: 1).tap()
        element.children(matching: .other).element(boundBy: 2).children(matching: .other).element(boundBy: 1).tap()
        
        let textView = tablesQuery.cells.containing(.staticText, identifier:"Note Content*").children(matching: .textView).element
        textView.tap()
        textView.typeText("This is sample note")
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["ADD NOTE"]/*[[".cells.buttons[\"ADD NOTE\"]",".buttons[\"ADD NOTE\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        
        
    }
    
    /*
     Execution Flow for Adding internal Note.
     Open App -> Load Inbox Tickets -> Click on side-menu side -> Click on Create Ticket row -> fill all the details -> click on submit button
     
     */
    
     func testCreateTicket() {
        
        // textView.typeText("This is the sample message")
        let app = XCUIApplication()
        app.navigationBars["Inbox"].buttons["Item"].tap()
        
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Create Ticket"]/*[[".cells.staticTexts[\"Create Ticket\"]",".staticTexts[\"Create Ticket\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Last Name"]/*[[".cells.staticTexts[\"Last Name\"]",".staticTexts[\"Last Name\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.textFields["john.admin@abc.com"]/*[[".cells.textFields[\"john.admin@abc.com\"]",".textFields[\"john.admin@abc.com\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let emailTextField = tablesQuery.textFields["john.admin@abc.com"]
        emailTextField.tap()
        emailTextField.typeText("sanjay.datta@cricket.com")
        
        let johnTextField = tablesQuery/*@START_MENU_TOKEN@*/.textFields["John"]/*[[".cells.textFields[\"John\"]",".textFields[\"John\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        johnTextField.tap()
        johnTextField.typeText("Sanjay")
        
        let fernandisTextField = tablesQuery/*@START_MENU_TOKEN@*/.textFields["Fernandis"]/*[[".cells.textFields[\"Fernandis\"]",".textFields[\"Fernandis\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        fernandisTextField.tap()
        fernandisTextField.typeText("Datta")
      
        let mobileTextField = tablesQuery.textFields["9158696985"]
        mobileTextField.tap()
        mobileTextField.typeText("9822741524")
        
        let subjectTextView = tablesQuery.cells.containing(.staticText, identifier:"Subject *").children(matching: .textView).element
        subjectTextView.tap()
        subjectTextView.typeText("This is sample subject for this ticket.")
        
        let messageTextView = tablesQuery.cells.containing(.staticText, identifier:"Message *").children(matching: .textView).element
        messageTextView.tap()
        messageTextView.typeText("This is sample message for this ticket")
        
        //Priority
        tablesQuery.textFields["High"].press(forDuration: 1.4);
        
        let doneButton = app.toolbars["Toolbar"].buttons["Done"]
        doneButton.tap()
        
        //Helptopic
         tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["HelpTopics *"]/*[[".cells.staticTexts[\"HelpTopics *\"]",".staticTexts[\"HelpTopics *\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
         tablesQuery.textFields["Support Query"].press(forDuration: 1.4);
         doneButton.tap()
        
        tablesQuery/*@START_MENU_TOKEN@*/.textFields["SLA 2"].press(forDuration: 1.1);/*[[".cells.textFields[\"SLA 2\"]",".tap()",".press(forDuration: 1.1);",".textFields[\"SLA 2\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/
       // app/*@START_MENU_TOKEN@*/.pickerWheels["Sla 2"]/*[[".pickers.pickerWheels[\"Sla 2\"]",".pickerWheels[\"Sla 2\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
        doneButton.tap()
        
        tablesQuery.buttons["Create Ticket"].tap()
        
       
    }
    
    func testEditTicketDetails() {
        
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Hey"].tap()
        
        app.navigationBars["Details"].buttons["pencileEdit"].tap()
        
        let messageTextView = tablesQuery.cells.containing(.staticText, identifier:"Subject *").children(matching: .textView).element
        messageTextView.tap()
        messageTextView.typeText("This is simple testing of edit ticket.")
        
        
         let doneButton = app.toolbars["Toolbar"].buttons["Done"]
        
         tablesQuery.cells.containing(.staticText, identifier:"Ticket Priority *").children(matching: .textField).element/*@START_MENU_TOKEN@*/.press(forDuration: 1.3);/*[[".tap()",".press(forDuration: 1.3);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
         doneButton.tap()
        
        
       // let cancelButton = app.toolbars.matching(identifier: "Toolbar").buttons["Cancel"]
       // cancelButton.tap()
        
        tablesQuery.cells.containing(.staticText, identifier:"HelpTopic *").children(matching: .textField).element/*@START_MENU_TOKEN@*/.press(forDuration: 1.4);/*[[".tap()",".press(forDuration: 1.4);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        doneButton.tap()
        
        tablesQuery.cells.containing(.staticText, identifier:"Ticket Source *").children(matching: .textField).element/*@START_MENU_TOKEN@*/.press(forDuration: 1.3);/*[[".tap()",".press(forDuration: 1.3);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        doneButton.tap()
        
        
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Update Details"]/*[[".cells.buttons[\"Update Details\"]",".buttons[\"Update Details\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
     
        
    
    }

    func testTest() {
        
    }

}
