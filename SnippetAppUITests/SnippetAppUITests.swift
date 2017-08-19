//
//  SnippetAppUITests.swift
//  SnippetAppUITests
//
//  Created by Joshua on 8/19/17.
//  Copyright © 2017 Joshua's Games. All rights reserved.
//

import XCTest

class SnippetAppUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    /*create a function that will utilize the UI Recorder
            -- the UI Recorder records whatever actions the programmer does and copies it so that it can be used later on also */
    
    //create a funtion that test that the "New? button is working in the User Interface
    func testSnippetSelectionOnNewPress(){
        //refernce the application 
        let app = XCUIApplication()
        
        //create and set the expectation 
        let selectionAlert = app.staticTexts["Select a snippet type"]
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: selectionAlert, handler: nil);
        
        //tap the button and wait for the expectation 
        XCUIApplication().toolbars.buttons["New"].tap()
        app.toolbars.buttons["New"].tap()
        waitForExpectations(timeout: 1, handler: nil)
    }
    
}
