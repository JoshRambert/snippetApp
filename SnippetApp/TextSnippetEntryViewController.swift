//
//  TextSnippetEntryViewController.swift
//  SnippetApp
//
//  Created by Joshua on 7/31/17.
//  Copyright © 2017 Joshua's Games. All rights reserved.
//

import Foundation
import UIKit

//declare the new class as a sublclass of the UITextViewController
class TextSnippetEntryViewController: UIViewController{
    
    //create the outlet for the textview from the viewController
    @IBOutlet weak var textEntryOutlet: UITextView!
    
    //necessary for every class that is partnered with a view controller
    override func viewDidLoad(){
    super.viewDidLoad()
        //this will add the keyboard to the textView when the View COntroller is Loaded/Inflated
        textEntryOutlet.inputAccessoryView = createKeyboardToolbar();
        
        //make sure that the TextView is the first responder bringing up the keyboard with this simple statement
        textEntryOutlet.becomeFirstResponder();
    }
}

//create an extension to implement the protocol
/*
 going to be adding a textView later that is why it is implemented now
 */
extension TextSnippetEntryViewController: UITextViewDelegate{
    
    //also create a function that will be called once the user is finished editing
    func textViewDidEndEditing(_textView: UITextView){

        //add code to this function to dismiss the textView once the user is done editing  and return to the main screen 
        dismiss(animated: true, completion: nil);
        
    }
    //create a function that places a "Done" button above the keyboard with a toolbar
    func createKeyboardToolbar() -> UIView {
        
        //create a constant for the toolBar and give it a width equal to the screen and a height of 44 
        /*
         The constnat that was assigned to the toolbar will be used through the rest of the function
         */
        let keyboardToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        
        //use the UIBarButtonItem to add buttons to the toolbar
        // --- this function adds the flexibleSpace button through code
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        //here we add the done button through code and call a function that is yet to be created --- but will be created down below
        /*
         Do not know all the aspects of a selector but here it is being used to call a function through an action of the "UIBarButtonItem"
         */
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
        
        //set the items within the toolbar then return the toolbar in the function
        keyboardToolbar.setItems([flexSpace, doneButton], animated: false)
        
        return keyboardToolbar;
    }
    
    //create the function "doneButtonPressed" which gets rid of the keyboard within the TexView
    func doneButtonPressed(){
        textEntryOutlet.resignFirstResponder();
    }
}
