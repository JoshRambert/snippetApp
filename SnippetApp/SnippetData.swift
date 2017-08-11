//
//  SnippetData.swift
//  SnippetApp
//
//  Created by Joshua on 7/29/17.
//  Copyright © 2017 Joshua's Games. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

//add the two types of snippet data(Photo, Text) using an enum
enum SnippetType: String {
    case text = "Text"
    case photo = "Photo"
}

//create the struct that will hold the data of the snippets
class SnippetData{
    
    //create a constant for the snippetType because it shouldnt change when chosen -- and one for the Date -- and lastly add one for the coordinate
    let type: SnippetType;
    let date: Date;
    let coordinate: CLLocationCoordinate2D?
    
    //create an init func that takes the snippet Type and displays wich one was chosen
    /*
     Created parameter for the InIt function and then assigned the parameter value to our type constant
     */
    init(snippetType: SnippetType, creationDate: Date, creationCoordinate: CLLocationCoordinate2D?) {
        //this is where the type of snippet is chosen
        type = snippetType
        date = creationDate;
        coordinate = creationCoordinate
        print("\(type.rawValue) snippet created on \(date) at \(coordinate.debugDescription)");
    }
}

class TextData: SnippetData{
    //create a variable to hold the text data
    let textData: String;
    
    //create the initializer for the textData Subclass that takes a string as an argument
    init(text: String, creationDate: Date, creationCoordinate: CLLocationCoordinate2D?){
        
        //assign the argument within the intializer to the constant
        textData = text;
        
        //call the super classes init func
        super.init(snippetType: .text, creationDate: creationDate, creationCoordinate: creationCoordinate);
    
        //print the text snippet data
        print("Text Snippet data \(textData)");
    }
}

//do what you did for the text data class except with the photo -- using UI image instead of a String 
class PhotoData : SnippetData {
    let photoData: UIImage
    
    init ( photo: UIImage, creationDate: Date, creationCoordinate: CLLocationCoordinate2D? ){
        photoData = photo
        super.init(snippetType: .photo, creationDate: creationDate, creationCoordinate: creationCoordinate)
        print("Photo snippet data: \(photoData)")
    }
}

