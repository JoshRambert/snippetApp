//
//  SnippetsAppTests.swift
//  SnippetsAppTests
//
//  Created by Joshua on 8/17/17.
//  Copyright © 2017 Joshua's Games. All rights reserved.
//

import XCTest
import CoreData
@testable import SnippetApp

class SnippetsAppTests: XCTestCase {
    //create references for the ViewController -- and the NSManagedObjectContext for the Data
    var vc: ViewController!
    var moc: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        //setup the references -- reference the storyBoard / create shortCut
        let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
        //instantiate / bring forth the initial viewController
        vc = sb.instantiateInitialViewController() as! ViewController
        
        //reference the AppDelegate class / create shortCut
        let delegate = UIApplication.shared.delegate as! AppDelegate
        moc = delegate.managedObjectContext // call the ManageObjectContext from the AppDelegate 
        
        //call a function called clearOutCoreData that we have not even created yet 
        clearOutCoreData()
    }
    
    func clearOutCoreData()
    {
        //create store the data array within the variable data
        var data: [NSManagedObject]!
        
        //create a fetch request for that will grab al of the snippet data
        let fetchRequests = NSFetchRequest<NSFetchRequestResult>(entityName: "Snippet")
        do
        {
            let fetchResults = try moc.fetch(fetchRequests)
            //store the snippet data within the array
            data = fetchResults as! [NSManagedObject]
        } catch {
            let e = error as Error
            print("Unresolved error \(e.localizedDescription)")
        }
        
        //llop through the array and delete each entry from the object context
        for d in data
        {
            moc.delete(d)
        }
    }
    
    //were going to call the savetextSnippet function from the ViewController then read the data back and make sure it is correct
    func testSaveTextSnippet()
    {
        //define the string we are passing in
        let testString = "test"
        //call the function on the viewController
        vc.saveTextSnippet(text: testString)
        
        //load in the NSManagedObject that was created, and check the data that was saved -- pull out all the snippet data from our core model data then (empty) except for the new data we just created 
        
        //Get the data from the CoreData -- so that it can be read back and double checked -- if it fails then something has gone wrong
        var data: [NSManagedObject]!
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Snippet")
        do
        {
            let fetchResults = try moc.fetch(fetchRequest)
            data = fetchResults as! [NSManagedObject]
        } catch {
            let e = error as Error
            print("Unresolved error \(e.localizedDescription)")
            XCTFail();
        }
        
        //validate the data 
        let snippet = data[0] // pull out the first element in the array
        if let rawType = snippet.value(forKey: "type") as? String, let string = snippet.value (forKey: "text") as? String { //access the values using "forKey" -- and cast to the expected type
            
            //this only gets run if the data is read properly -- checking to see if the data is text -- then checks to see if the text is correct 
            XCTAssertEqual(SnippetType(rawValue: rawType), SnippetType.text)
            XCTAssertEqual(string, testString)
        } else { // if they fail it will fall to this else statement
            XCTFail()
        }
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
