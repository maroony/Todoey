//
//  AppDelegate.swift
//  Todoey
//
//  Created by Andy on 28.10.18.
//  Copyright © 2018 Andy Schoenemann. All rights reserved.
//

import RealmSwift
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    print(Realm.Configuration.defaultConfiguration.fileURL)

    do {
      _ = try Realm()
    } catch {
      print("Error on initialisation of Realm, \(error)")
    }
    return true
  }
}
