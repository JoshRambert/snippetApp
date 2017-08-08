//
//  ViewController.swift
//  SnippetApp
//
//  Created by Joshua on 7/29/17.
//  Copyright © 2017 Joshua's Games. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //create a reference for the tableView 
    @IBOutlet weak var tableView: UITableView!
    
    //declare an array of snippetData -- And Create a new instance of the Image picker
    var data: [SnippetData] = [SnippetData]();
    let imagePicker = UIImagePickerController();

    override func viewDidLoad() {
        super.viewDidLoad();
        //assign the Delegate for the Image Picker to the ciew controller class
        imagePicker.delegate = self;
        
        //tell the table view to match the height of whatever the user input 
        tableView.estimatedRowHeight = 100;
        tableView.rowHeight =  UITableViewAutomaticDimension
    }
    
    //tell the app when to load the data 
    override func viewWillAppear(_ animated: Bool){
        tableView.reloadData();
    }

    //create the action function that will create the new snippets
    /*
     How an Action func is supposed to look 
     *
     */
    @IBAction func createNewSnippet(_sender: AnyObject) {
        //create the UI alert controllers to prompt the the user to select a type of snippet start with the constants
        let alert = UIAlertController(title: "Select a Snippet type", message: nil, preferredStyle: .actionSheet);
        /*
         Here the UIAlertActions work more as an option menu for the user
         *
         Each alert has three things that have to be inside of it -- the "Title" the "Style" and the completion handler which is what it does when the button is clicked.
         *
         *
         in the final parts of the UIAlertActions we are initiliazing and appending the SnippetData Struct to the Data Array
         *
         the "self" keyword makes it so that you are explicit about the scope and reuse it whenever the completion handler is run
         */
        
        //create the UIAlertAction for when the user chooses text
        let textAction = UIAlertAction(title: "Text", style: .default) { (alert: UIAlertAction!) -> Void in self.createNewTextSnippet()
        }
        
        //create the UIAlertAction for when the user chooses a photo
        let photoAction = UIAlertAction(title: "Photo", style: .default) {(alert: UIAlertAction!) -> Void in self.createNewPhotoSnippet()
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
    
    //create the function for loading/inflating the textEntrySnippet
    func createNewTextSnippet() {
        guard let textEntryVC = storyboard?.instantiateViewController(withIdentifier: "textSnippetEntry") as? TextSnippetEntryViewController
            else {
                print("TextSnippetEntryViewController could not be instantiated from StoryBoard")
                return
        }
        
        //this is the transition style from one view controller to the next -- it will slide up from the bottom when presented
        textEntryVC.modalTransitionStyle = .coverVertical;
        
        //redfine the body of the other view Controllers saveText closure to append the textSnippet to the data array
        textEntryVC.saveText = {(text: String)
            in
            let newTextSnippet = TextData(text: text)
            self.data.append(newTextSnippet);
        }
        
        present(textEntryVC, animated: true, completion: nil);
    }
    
    func createNewPhotoSnippet (){
        guard UIImagePickerController.isSourceTypeAvailable(.camera)
            else {
                print("Camera is not available")
                return
        }
        
        //allows user to crop photo
        imagePicker.allowsEditing = true;
        //allows the user to take a picture with the camera -- can also access library if needed with outher source types 
        imagePicker.sourceType = .camera;
        
        present(imagePicker, animated: true, completion: nil)
    }
}

//create the UIViewController class extension that will utilize the Image picker controller -- 
//the Navigation controller is initiated but not utilized here
extension ViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    //implement a function that will be called when we finish taking our picture
    func imagePickerController(_ picker : UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage
            else{
                print("Image could not be found")
                return
        }
        let newPhotoSnippet = PhotoData(photo: image)
        self.data.append(newPhotoSnippet)
        
        //dismiss the photo snippet 
        dismiss(animated: true, completion: nil)
    }
}

//add another extension to implement a protocol 
extension ViewController : UITableViewDataSource {
    
    //this function retrun an int to tell how many sections there will be
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1;
    }
    
    //this function returns an int to tell how many rows there will be
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return the amount of data within the array
        return data.count;
    }
    
    //the final function tells the table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        //reverses the way in which the data is displayed
        let sortData = data.reversed() as [SnippetData]
        //ask for the specific type of data at the specific row
        let snippetData = sortData[indexPath.row]
        
        //create a aswitch statement depending on what type of data it is
        switch snippetData.type{
        case .text: cell = tableView.dequeueReusableCell(withIdentifier: "textSnippetCell", for: indexPath)
            (cell as! TextSnippetCell).label.text = (snippetData as! TextData).textData
            
        case .photo: cell = tableView.dequeueReusableCell(withIdentifier: "photoSnippetCell", for: indexPath)
        (cell as! PhotoSnippetCell).photo.image = (snippetData as! PhotoData).photoData
        }
        return cell;
    }
}

