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
import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    //create a new enum for the shortCutItems that has a string as a backing item 
    enum ShortCutItems : String {
        case newText = "Rambo.SnippetApp.createTextSnippet"
        case newPhoto = "Rambo.SnippetApp.createPhotoSnippet"
    }
    
    //create an empty function to lay down some groundwork for the shortcuts -- this first function is where we are going to write the logic to determine what shortcut was executed and what to do about it
    func handleShortcut(shortCutItem: UIApplicationShortcutItem) {
        //here is how we will gain access to files from the App delegate
        
        //call the functions from within the app to the Case Statements
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
        let vc = self.window!.rootViewController!
        if vc.presentedViewController != nil{
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
            handleShortcut(shortCutItem: shortcutItem)
        }
        //call the first function in this function
        handleShortcut(shortCutItem: shortcutItem);
    }

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
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
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:. -- call the saved Data function here
        self.saveContext();
    }
    
    //create the MOM or NSManagedObjectModel function -- this loads in the data model that we created within the data model editor
    // MARK: - Core Data Stack
    lazy var managedObjectModel: NSManagedObjectModel = {
        //retrieve the location of the data model
        let modelURL = Bundle.main.url(forResource: "SnippetData", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    //setup the NSPersistentStoreCoordinator -- this is the saved data that exists on the disk -- it uses the data model to know what the data should look like, then coordinates creating new data and saving data to the disk 
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        //instantiate a new persistantStoreCoordinator by passing in the managed object model -- so that it knows what it looks like
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let urls = FileManager.default.urls( for: .documentDirectory, in: .userDomainMask) //get the location of the dataBase
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
    
    //next is the NSMangedObjestContext  -- purpose is to provide an area to play with our data. It is here that we will edit data and create new instances of data
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
         -- ManagedObjestModel describes our data
         -- PersistantStoreCoordinator interfaces with the dataBase
         -- ManagedObjectContext lets us create, edit and save data
         */
    
    //create a helper function that makes it really easy to save data 
    //MARK: - Core data Saving Support 
    func saveContext (){
        if managedObjectContext.hasChanges{ //check to see if weve made any changes
            do {
                try managedObjectContext.save(); //save the data id there are any changes
            } catch{
                //replace this to handle erros appropriately 
                let nserror = error as NSError
                print("Unresloved error \(nserror), \(nserror.userInfo)")
                abort();
            }
        }
    }
}

