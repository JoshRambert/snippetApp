//
//  TextSnippetCell.swift
//  SnippetApp
//
//  Created by Joshua on 8/7/17.
//  Copyright © 2017 Joshua's Games. All rights reserved.
//

import UIKit
import Foundation

class TextSnippetCell: UITableViewCell{
    @IBOutlet var label: UILabel!;
    @IBOutlet var date: UILabel!;
    //create a closurer to send code between the viewController and the textSnippetCell class
    var shareButton: (() -> Void)?
    
    //add the function stub that will be used once the tweet button is pressed 
    @IBAction func shareButtonPressed(){
        if let callBack = shareButton{
            callBack();
        }
    }
}
