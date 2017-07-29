//
//  SnippetData.swift
//  SnippetApp
//
//  Created by Joshua on 7/29/17.
//  Copyright © 2017 Joshua's Games. All rights reserved.
//

import Foundation
//BARE_BONES walk through

//create the struct that will hold the data of the snippets 
struct SnippetData{
    
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
    
    //add the two types of snippet data(Photo, Text) using an enum
    enum SnippetType: String {
        case text = "Text"
        case photo = "Photo"
    }
}

