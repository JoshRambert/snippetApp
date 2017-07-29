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
        //create a constant that will store the snippetData then add the snippetdata to the snippetData Array
        
        let newSnippet = SnippetData(); /* The "SnippetData on the left hand side is referring to the Struct file we created earlier */
        data.append(newSnippet);
    }

}

