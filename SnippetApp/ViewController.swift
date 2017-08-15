//
//  ViewController.swift
//  SnippetApp
//
//  Created by Joshua on 7/29/17.
//  Copyright © 2017 Joshua's Games. All rights reserved.
//

//import the location class 
import CoreLocation
import UIKit
import Social
import CoreData

class ViewController: UIViewController {
    //declare an array of snippetData -- And Create a new instance of the Image picker -- create a property for to manage the Location
    var data = [NSManagedObject](); //this is the type of data that CoreData will load the entities into
    let imagePicker = UIImagePickerController();
    let locationManager = CLLocationManager();
    
    //create a variable that will handle what actually happens when the location update is successfull
    var currentCoordinate: CLLocationCoordinate2D?;
    
    //create a reference for the tableView
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        //assign the Delegate for the Image Picker to the ciew controller class
        imagePicker.delegate = self;
        
        //set the delegate of our location manager to the View Controller so it knows which ones to handle 
        locationManager.delegate = self;
        
        //create some more properties for actually locating the user -- the first one sets the desired accuracy to its highest setting and then set the distance filter to 50 -- the distance filter tells the location manager how far away user must mover in order to update the location (in meters)
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = 50.0
        
        //tell the table view to match the height of whatever the user input 
        tableView.estimatedRowHeight = 100;
        tableView.rowHeight =  UITableViewAutomaticDimension
        
        //call the Location permission func 
        askForLocationPermissions();
    }
    
    //tell the app when to load the data 
    override func viewWillAppear(_ animated: Bool){
        //load the snippetData upon finished creation
        reloadSnippetData();
        tableView.reloadData();
    }
    
    //create a new function to load the new and improved data 
    func reloadSnippetData(){
        //create a shortcut to the appDelegate class 
        let delegate = UIApplication.shared.delegate as! AppDelegate
        //access the managedContext
        let managedContext = delegate.managedObjectContext
        
        //create a "Fetch Request" -- or descride what information we want from our dataBase -- ask for a certain type of entity ordered in a certain way
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Snippet") //call the snippet entity to retrieve both Photo and Text entites -- reason: Base entity
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false) // tell the dataBase how you want the data to be sorted
        request.sortDescriptors = [sortDescriptor] // in order to attach the sortDescriptor it needs to be put into an array sincee it is possible to attach multiple
        
        //execute the fetch request 
        do{
            let fetchResults = try managedContext.fetch(request)
            self.data = fetchResults as! [NSManagedObject]
        } catch {
            let e = error as NSError
            print("Unresolved error \(e), \(e.userInfo)")
        }
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
            //let newTextSnippet = TextData(text: text, creationDate: Date(), creationCoordinate: self.currentCoordinate)
            self.saveTextSnippet(text: text); //call in the save function and pass in the text we want to save
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
    
    //create a new function for Saving text data -- in this funtion we are going to get acces to the Core Data stack, create a new instance of an entity and then configure the entity
    func saveTextSnippet(text: String){
        //create the properties that will hold the instance of the App delegate -- create a shotCut to the appDelegate so that its managedContext function can be accessed
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = delegate.managedObjectContext //NSManagedObject is a data container that can contain any type of data that we want
        
        //tell the managedObject what entity from our model we want it to represent with the descriptor keyword
        let desc = NSEntityDescription.entity(forEntityName: "Textsnippet", in: managedContext) //so it knows which entity it represents
        let textSnippet = NSManagedObject(entity: desc!, insertInto: managedContext) //insert into the scratchPad
        
        //in order to set all of the attributes that we defined in the textSnippet entity we use the key/value encoding
        textSnippet.setValue(SnippetType.text.rawValue, forKey: "type");
        textSnippet.setValue(text, forKey: "text")
        textSnippet.setValue(NSDate(), forKey: "date")
        if let coord = self.currentCoordinate{
            textSnippet.setValue(coord.latitude, forKey: "latitude")
            textSnippet.setValue(coord.longitude, forKey: "longitude")
        }
        delegate.saveContext();
    }
    
    //create a new function for saving photo Data -- very similar to the saving text function
    func savePhotoSnippet(photo: UIImage){
        //repeat alot of the processes you did in the saveTextSnippet function
        let delegate = UIApplication.shared.delegate as! AppDelegate //create a shortcut to the appDelegate class
        let managedContext = delegate.managedObjectContext //access the managedContext function from the appDelegate class
        let desc = NSEntityDescription.entity(forEntityName: "PhotoSnippet", in: managedContext)
        let photoSnippet = NSManagedObject(entity: desc!, insertInto: managedContext)
        let photoData = UIImagePNGRepresentation(photo) // create a new piece of data called photoData -- raw repesentation of the image whcih we get by passing in our UIImage to the function
        
        //set up te attriubutes for the photoSnippet entity 
        photoSnippet.setValue(SnippetType.photo.rawValue, forKey: "type")
        photoSnippet.setValue(photoData, forKey: "photo")
        photoSnippet.setValue(Data(), forKey: "date")
        if let coord = self.currentCoordinate{
            photoSnippet.setValue(coord.latitude, forKey: "latitude")
            photoSnippet.setValue(coord.longitude, forKey: "longitude")
        }
        delegate.saveContext();
    }
    
    //create a function that asks for location permission 
    func askForLocationPermissions(){
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization();
        }
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
        
        //add the replacement data for the imagePickerControllerFuntion
        savePhotoSnippet(photo: image)

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
        
        //upgrade the TableView function to display data from our corData model 
        let snippetData = data[indexPath.row] //pull out the data and have it displayed at the same inde number within the cell as it is in the array
        let snippetDate = snippetData.value(forKey: "date") as! Date //pull out the date from the Database and force cast it to the "Date" type
        let snippetType = SnippetType(rawValue: snippetData.value(forKey: "type") as! String)! //pull out the string type too -- use the raw data to instantiate the SnippetType enum
        
        //format the date stored in the Date to something readable a, and then assign the string to our date label 
        let formatter = DateFormatter();
        formatter.dateFormat = "MMM d, yyyy hh:mm a"
        //updated dateString to use the new snippetDate value
        let dateString = formatter.string(from: snippetDate);
        
        //create a aswitch statement depending on what type of data it is
        switch snippetType{
            //add the new CoreData code - pull out the string for the text attributes -- then replace all previous instance of text with just snippetText
        case .text:
            let snippetText = snippetData.value(forKey: "text") as! String
        cell = tableView.dequeueReusableCell(withIdentifier: "textSnippetCell", for: indexPath) as! TextSnippetCell
        (cell as! TextSnippetCell).label.text = snippetText;
        //assign the date String to our date label
        (cell as! TextSnippetCell).date.text = dateString
        
        //setup the tweet button within our cell -- this is the code that will be passed into the closures that we created within our textSnippetCells and photoSnippetCells
        (cell as! TextSnippetCell).shareButton = {
            //check to see if twitter is available
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter){
            let text = snippetText  //get the useers text from the textdata object
                
            //create the viewController for creating a tweet -- placed in a guard statement to ensure that there is a value
            guard let twVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                else {
                print("Couldn't create twitter compose controller")
                    return
                    }
                
                //check the length of the text data since twitter only supports 140 characters -- use the "setInitialText()" function to prePopulate the text field
                if text.characters.count <= 140 {
                twVC.setInitialText("\(text)")
                } else {
                    let tweetLengthIndex = text.index(text.startIndex, offsetBy: 140)
                    let tweetChars = text.substring(to: tweetLengthIndex)
                    twVC.setInitialText("\(tweetChars)")
                    }
                //lastly present the viewController
                self.present(twVC, animated: true, completion:nil)
                }
            else {
             let alert = UIAlertController(title: "You are not logged into twitter", message: "Please log into Twitter from the iOS Settings app.", preferredStyle: .alert)
            
                let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil);
                
            //add the alerts 
                alert.addAction(dismissAction);
                self.present(alert, animated: true, completion: nil);
            }
        }
            
        
        case .photo:
            let snippetPhoto = UIImage(data: snippetData.value(forKey: "photo") as! Data) //pull out the data for the photo attributes -- and pass it into a raw image attribute 
            cell = tableView.dequeueReusableCell(withIdentifier: "photoSnippetCell", for: indexPath)
                (cell as! PhotoSnippetCell).photo.image = snippetPhoto;
        //add the social code for posting to twitter
        (cell as! PhotoSnippetCell).shareButton = {
            
            //setup the tweet button for the Photo snippets
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter){
                let photo = snippetPhoto;
                guard let twVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter) else{
                    print("Couldn't create twitter compose controller")
                    return
                    }
                twVC.setInitialText("Sent from Snippets");
                twVC.add(photo)
                self.present(twVC, animated: true, completion: nil)
                }
            else{
                let alert = UIAlertController(title: "You are not logged into twitter", message: "Please log into Twitter form the iOS settings app.", preferredStyle: .alert)
                
                let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                //add the alerts 
                alert.addAction(dismissAction)
                self.present(alert, animated: true, completion: nil)
                }
            }
        }
        return cell;
    }
    //create the function that will make it possible to delete old snippets
    @objc(tableView:commitEditingStyle:forRowAtIndexPath:) func tableView(_ tableView: UITableView, commit editingStlye: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        //in order to completely erase snippet: First delete data from managed context -- then delete the table view cell
        
        //create a shortcut to the AppDelegate
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = delegate.managedObjectContext
        
        //locate the piece of data that has been selected  -- then the delete button to do its job
        let currentObject = data[indexPath.row]
        managedContext.delete(currentObject)
        
        //then save what is left of the data and reload the Snippet data.
        delegate.saveContext()
        reloadSnippetData()
        
        //open up the tableViews for updates delete the rows selected then close the updates option.
        tableView.beginUpates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        
    }
}

//create another class extension for the functinoality of the location within the app 
extension ViewController : CLLocationManagerDelegate{
    //this function is called when the location manager first starts up and if the authorization is ever changed
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
          locationManager.startUpdatingLocation()
        }
    }
    
    //create two more functions -- one that handles a successful Locationupdate and another that handles an error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager could not get location.Error: \(error.localizedDescription)")
    }
    
    //create the function that lets us know about the succesful location update
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last {
            currentCoordinate = currentLocation.coordinate
            print("\(currentCoordinate!.latitude), \(currentCoordinate!.longitude)")
        }
    }
}

