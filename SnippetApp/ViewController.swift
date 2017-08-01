//
//  ViewController.swift
//  SnippetApp
//
//  Created by Joshua on 7/29/17.
//  Copyright © 2017 Joshua's Games. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //declare an array of snippetData
    var data: [SnippetData] = [SnippetData]();

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //create the action function that will create the new snippets
    /*
     How an Action func is supposed to look 
     *
     *
     *
     */
    @IBAction func createNewSnippet(_sender: AnyObject) {
        //create the UI alert controllers to prompt the the user to select a type of snippet start with the constants
        let alert = UIAlertController(title: "Select a Snippet type", message: nil, preferredStyle: .actionSheet);
        /*
         Here the UIALertActions work more as an option menu for the user
         *
         Each alert has three things that have to be inside of it -- the "Title" the "Style" and the completion handler which is what it does when the button is clicked.
         *
         *
         in the final parts of the UIAlertActions we are initiliazing and appending the SnippetData Struct to the Data Array
         *
         the "self" keyword makes it so that you are explicit about the scope and reuse it whenever the completion handler is run
         */
        
        //create the UIAlertAction for when the user chooses text
        let textAction = UIAlertAction(title: "Text", style: .default) { (alert: UIAlertAction!) -> Void in self.data.append(SnippetData(snippetType: .text))
        }
        
        //create the UIAlertAction for when the user chooses a photo
        let photoAction = UIAlertAction(title: "Photo", style: .default) {(alert: UIAlertAction!) -> Void in self.data.append(SnippetData(snippetType: .photo))
        }
        
        //create the UIALertAction for when the User chooses to cancel making a snippet 
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        //add the alert actions to the UIAlertController
        /*
         THe UIAlertController is the Window while the ALertACtions are the objects/Button within the window.
         */
        alert.addAction(textAction)
        alert.addAction(photoAction)
        alert.addAction(cancelAction)
        
        ///present the ViewController 
        present(alert, animated: true, completion: nil);
    }
}

