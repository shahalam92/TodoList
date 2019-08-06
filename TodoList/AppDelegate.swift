//
//  AppDelegate.swift
//  TodoList
//
//  Created by xdMM20181201 on 30/07/19.
//  Copyright © 2019 xdMM20181201. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print(Realm.Configuration.defaultConfiguration.fileURL!)
   
        return true
    }

}

