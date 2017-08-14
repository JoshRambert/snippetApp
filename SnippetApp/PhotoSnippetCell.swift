//
//  PhotoSnippetCell.swift
//  SnippetApp
//
//  Created by Joshua on 8/7/17.
//  Copyright © 2017 Joshua's Games. All rights reserved.
//

/*
 Eventually add the tweet button and the data button to the photo Entry when ready
 */
import UIKit
import Foundation

class PhotoSnippetCell: UITableViewCell{
    @IBOutlet var photo: UIImageView!
    var shareButton: (() -> Void)?
    
    //create a funciton that will be called once the tweet button has been pressed 
    @IBAction func shareButtonPressed(){
        if let callBack = shareButton{
            callBack();
        }
    }
}


