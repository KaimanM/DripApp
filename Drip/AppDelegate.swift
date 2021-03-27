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
//        window?.rootViewController = DarkNavController(rootViewController: WelcomeScreenBuilder().build())
        window?.rootViewController = TabBarScreenBuilder().build()
//        window?.rootViewController = OnboardingPagesScreenBuilder().build()
        self.window?.makeKeyAndVisible()

        UIApplication.shared.isIdleTimerDisabled = true

        return true
    }

}
