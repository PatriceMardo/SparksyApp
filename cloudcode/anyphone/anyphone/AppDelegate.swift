//
//  AppDelegate.swift
//  AnyPhone
//
//  Created by Fosco Marotto on 5/6/15.
//  Copyright (c) 2015 parse. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

    Parse.enableLocalDatastore()
		Parse.setApplicationId("Fuz6DkPYCt00odhvTEaXsAcfC4nNioMwfvPmMR1Y",
      clientKey: "RRQUhNE7MuG0UTXSdy5TIa71PequpnDxSyR9qWpC")

    PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)

    return true
  }
  
}
