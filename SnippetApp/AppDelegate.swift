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
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

