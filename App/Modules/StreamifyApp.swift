//
//  StreamifyApp.swift
//  Streamify
//
//  Created by Omar Waked on 7/14/24.
//

import SwiftUI
import GoogleMobileAds

class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(_ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    GADMobileAds.sharedInstance().start(completionHandler: nil)
    GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "bafec33024aff648439b50aafd124a84" ]

    return true
  }
}

@main
struct StreamifyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var signInViewModel = SignInViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(signInViewModel)
        }
    }
}
