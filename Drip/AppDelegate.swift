//
//  AppDelegate.swift
//  Drip
//
//  Created by Kaiman Mehmet on 25/04/2020.
//  Copyright © 2020 Kaiman Mehmet. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        window = UIWindow(frame: UIScreen.main.bounds)

        switch UserDefaultsController.shared.completedOnboarding {
        case false:
            window?.rootViewController = OnboardingPagesScreenBuilder().build()
        case true:
            window?.rootViewController = TabBarScreenBuilder().build()
        }

        self.window?.makeKeyAndVisible()

        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Saves Data on exit.
        CoreDataController.shared.saveContext()
    }

}
