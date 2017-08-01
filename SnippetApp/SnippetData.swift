//
//  SnippetData.swift
//  SnippetApp
//
//  Created by Joshua on 7/29/17.
//  Copyright © 2017 Joshua's Games. All rights reserved.
//

import Foundation
//BARE_BONES walk through

//add the two types of snippet data(Photo, Text) using an enum
enum SnippetType: String {
    case text = "Text"
    case photo = "Photo"
}

//create the struct that will hold the data of the snippets
class SnippetData{
    
    //create a constant for the snippetType because it shouldnt change when chosen
    let type: SnippetType;
    
    //create an init func that takes the snippet Type and displays wich one was chosen
    /*
     Created parameter for the InIt function and then assigned the parameter value to our type constant
     */
    init(snippetType: SnippetType) {
        
        //this is where the type of snippet is chosen
        type = snippetType
        print("\(type.rawValue) Snippet created");
    
    }
}

class textData: SnippetData{
    //create a variable to hold the text data
    let textData: String;
    
    //create the initializer for the textData Subclass that takes a string as an argument
    init(text: String){
        
        //assign the argument within the intializer to the constant
        textData = text;
        
        //call the super classes init func
        super.init(snippetType: .text);
        
        //print the text snippet data
        print("Text Snippet data \(textData)");
    }
}

