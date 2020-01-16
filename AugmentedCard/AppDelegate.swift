//
//  AppDelegate.swift
//  ARKitImageRecognition
//
//  Created by Marcel Mierzejewski on 07/01/2019.
//  Copyright © 2019 Snow.dog. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Fabric.with([Crashlytics.self])

//        //REMOVE ME
//        window = UIWindow(frame: UIScreen.main.bounds)
//        window?.rootViewController = UINavigationController(rootViewController: CardDetailsViewController())
//        window?.makeKeyAndVisible()
//        //END OF REMOVE

        return true
    }
}
