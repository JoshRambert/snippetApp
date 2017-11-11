//
//  AppDelegate.swift
//  SnippetApp
//
//  Created by Joshua on 7/29/17.
//  Copyright © 2017 Joshua's Games. All rights reserved.
//

/*
 App delegate is where we take care of launching, entering and exiting the app -- the highest level of control
 */

//"self" represents the current class instance -- in this case the AppDelegate would be the current class instance

import UIKit
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    //create a new enum for the shortCutItems that has a string as a backing item 
    enum ShortCutItems : String {
        case newText = "Rambo.SnippetApp.createTextSnippet"
        case newPhoto = "Rambo.SnippetApp.createPhotoSnippet"
    }
    
    //create an empty function to lay down some groundwork for the shortcuts -- this first function is where we are going to write the logic to determine what shortcut was executed and what to do about it
    func handleShortcut(shortCutItem: UIApplicationShortcutItem) {
        //for each shortcutItem inflate either the createNewtext ViewController or the newPhotoViewController
        switch shortCutItem.type {
        case ShortCutItems.newText.rawValue: let vc = self.window!.rootViewController as! ViewController
        vc.createNewTextSnippet();
        case ShortCutItems.newPhoto.rawValue: let vc = self.window!.rootViewController as! ViewController
        vc.createNewPhotoSnippet();
        default:
            break
        }
    }
    
    //the next function is from the UIApplicationDelegate Protocol and will get automatically called when we launch the app 
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void){
        //here we are going to check if the user left the view Controller open before calling the shortcut again ---
        let vc = self.window!.rootViewController! // this is the window for the rootViewController
        if vc.presentedViewController != nil{ //if the viewController was left open -- either close the current snippet or continue snippeting
            
            //use alert controller to ask the user -- continue the Action -- and erase the action
            let alert = UIAlertController(title: "Unifinished Snippet", message: "Do you want to continue creating this snippet, or erase and start a new snippet?", preferredStyle: .alert)
            let continueAction = UIAlertAction(title: "Continue", style: .default, handler: nil)
            let eraseAction = UIAlertAction(title: "Erase", style: .destructive) {(alert: UIAlertAction!) -> Void in
                vc.dismiss(animated: true, completion: nil)
                self.handleShortcut(shortCutItem: shortcutItem);
            }
            alert.addAction(continueAction)
            alert.addAction(eraseAction)
            vc.presentedViewController!.present(alert, animated: true, completion: nil)
        } else{
            //continue on with the shortCut action
            handleShortcut(shortCutItem: shortcutItem)
        }
        //call the shortCutItem Function
        handleShortcut(shortCutItem: shortcutItem);
    }

    var window: UIWindow?

    //add some notificaiton setup code
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        // Override point for customization after application launch.
        
        //grab a reference to the UserNotificationCenter 
        let center = UNUserNotificationCenter.current()
        
        //setup up the delegate for the notifications
        center.delegate = self;
        center.requestAuthorization(options: [.alert, .badge, .sound])// assign the type of notification there will be -- in this case alert, bagde and sound are used
        {
            granted, error in if granted //just the syntax used for the UserNotificationCenter
            {
                //make a reference to the notification categories 
                center.setNotificationCategories(self.getNotificationCategories())
                //call the function we just created
                self.scheduleReminderNotification()
            }
        }
        return true
    }
    
    //create a new function to create and trigger the notifications
    func scheduleReminderNotification(){
        //get a reference to the Current UNUserNotificationCenter which we will set to schedule the notifications later
        let center = UNUserNotificationCenter.current()
        
        center.removeAllPendingNotificationRequests(); //removed all pending requests for some reason
        center.getPendingNotificationRequests(){
        pendingRequests in
            //Check to see if there are already notifications in our app -- create a new notification and store it unless it already exists
            guard !pendingRequests.contains(where: {r in r.identifier == "Snippets.Reminder"})
                else{
                print("Notification already exists")
                    return
            }
            
            //Reference the NotificationContent -- Create the new reminder notification -- assign the content of the notification
            let content = UNMutableNotificationContent()
            content.title = "Reminder"
            content.body = "Have you Snipped anything lately?"
            content.sound = UNNotificationSound.default()
            //assign the category to the daily reminders
            content.categoryIdentifier = "Snippets.Category.Reminder"
            content.badge = 1
            
            //create the date or time of day for when the notification goes off -- add a minute and a second
            var fireDate = DateComponents()
            fireDate.hour = 17
            fireDate.minute = 13
            fireDate.second = 40
            
            //this is how often the notification goes off -- (Everyday at 12)
            let trigger = UNCalendarNotificationTrigger(dateMatching: fireDate, repeats: true)
            
            //Create a request for that notification then display that notification throught] the UNUserNotificationCenter
            let request = UNNotificationRequest(identifier: "Snippets.Reminder", content: content, trigger: trigger)
            center.add(request, withCompletionHandler: nil);
        }
    }
    
    //create a function for Notification Categories 
    func getNotificationCategories() -> Set<UNNotificationCategory>
    {
        //create a text action -- give it a title and ID -- this will ultimately allow us to create a textSnippet straight from the notification
        let textAction = UNNotificationAction(identifier: "Snippets.Action.NewText", title: "New Text", options: [.authenticationRequired, .foreground]) //the options section makes sure to unlock the phone and the .foreground part opens the app when it is pressed
        
        //do the same for the Photo Snippets
        let photoAction = UNNotificationAction(identifier: "Photo.Action.NewPhoto", title: "New Photo", options: [.authenticationRequired, .foreground])
        
        //create the Category in which the actions will get stored -- intentIdentifiers  and options are left blank
        let reminderCategory = UNNotificationCategory(identifier: "Snippets.Category.Reminder", actions: [textAction, photoAction], intentIdentifiers: [], options: [])
        
        //return the category 
        return Set<UNNotificationCategory>([reminderCategory])
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        //set the badge icon to 0 once the app is opened
        application.applicationIconBadgeNumber = 0;
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:. 
        
        //-- call the saved Data function here
        self.saveContext();
    }
    // MARK: - Core Data Stack -- First it is created within the ModelData class then it is initialized here 

    //create the MOM or NSManagedObjectModel function -- this loads in the data model that we created within the data model editor
    lazy var managedObjectModel: NSManagedObjectModel = {
        //retrieve the location of the data model
        let modelURL = Bundle.main.url(forResource: "SnippetData", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    //setup the NSPersistentStoreCoordinator -- this is the saved data that exists on the disk -- it uses the data model to know what the data should look like, then coordinates creating new data and saving data to the disk 
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        //instantiate a new persistantStoreCoordinator by passing in the managed object model -- so that it knows what it looks like
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask) //get the location of the dataBase
        let url = urls.last!.appendingPathComponent("SingleViewCoreData.sqlite")
        
        do { //load the dataBase from the URL
          try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        }catch {
          //replace this to handle the error appriopriately 
          let nserror = error as NSError
            print ("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        return coordinator
    }()
    
    //next is the NSManagedObjectContext -- purpose is to provide an area to play with our data. It is here that we will edit data and create new instances of data -- this is also public to the rest of the application
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        //create new instance of the class and pass in the type
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        //assign the persistant store coordinator to be the instance
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    /*
        REVIEW 
         -- ManagedObjectModel describes our data
         -- PersistantStoreCoordinator interfaces with the dataBase
         -- ManagedObjectContext lets us create, edit and save data
         */
    
    //create a helper function that makes it really easy to save data 
    //MARK: - Core data Saving Support 
    func saveContext (){
        if managedObjectContext.hasChanges{ //check to see if weve made any changes
            do {
                try managedObjectContext.save(); //save the data if there are any changes
            } catch{
                //replace this to handle errors appropriately 
                let nserror = error as NSError
                print("Unresloved error \(nserror), \(nserror.userInfo)")
                abort();
            }
        }
    }
}

//create an extension of the AppDelegate class and then create a function within it to make the notification buttons dp what they are supposed to do
extension AppDelegate: UNUserNotificationCenterDelegate{
    
    //for right now we are only concerned with the response parameter -- which deals with how the notification is responded to
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        switch response.actionIdentifier{
            //create the action for the Text Button
            case "Snippets.Action.NewText": let vc = self.window!.rootViewController as! ViewController
            vc.createNewTextSnippet();
            
            //create the Action for the Photo Button
            case "Snippets.Action.NewPhoto": let vc = self.window!.rootViewController as! ViewController
            vc.createNewPhotoSnippet();
        default: break
        }
        //call completionHandler or else app crashes
        completionHandler()
    }
    
    //create new funciton for displaying notifications while in the app
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        //create a reference to the notification request content
        let content = notification.request.content
        //create an if statement to see which category it belongs to
        if content.categoryIdentifier == "Snippets.Category.Reminder"
        {
            //reference the rootViewController
            let vc = self.window!.rootViewController as! ViewController
            
            //instantiate alert using the title and body
            let alert = UIAlertController(title: content.title, message: content.body, preferredStyle: .alert)
            
            //create the photo, text and cancel actions -- then add them to the window
            let newTextSnippetAction = UIAlertAction(title: "New Text Snippet", style: .default){(action: UIAlertAction) in vc.createNewTextSnippet()}
            
            let newPhotoSnippetAction = UIAlertAction(title: "New Photo Snippet", style: .default){(action: UIAlertAction) in vc.createNewPhotoSnippet()}
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(newTextSnippetAction)
            alert.addAction(newPhotoSnippetAction);
            alert.addAction(cancelAction) // dont forget the cancel action
            
            //present them
            vc.present(alert, animated: true, completion: nil)        }
    }
}

