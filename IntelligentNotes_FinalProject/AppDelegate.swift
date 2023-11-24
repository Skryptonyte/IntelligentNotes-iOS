//
//  AppDelegate.swift
//  IntelligentNotes_FinalProject
//
//  Created by Rayhan Faizel on 15/11/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        DBManager.executeQuery(query: "CREATE TABLE IF NOT EXISTS notes(noteid integer primary key autoincrement, name varchar(40), content varchar(1000), folderid int, modifyTime int)")
        DBManager.executeQuery(query: "CREATE TABLE IF NOT EXISTS folders(folderid integer primary key autoincrement, folderName varchar(40))")
        DBManager.executeQuery(query: "INSERT INTO folders(folderid,foldername) SELECT 1, 'Main' WHERE NOT EXISTS(SELECT 1 FROM folders WHERE folderid = 1 AND foldername = 'Main');")
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

