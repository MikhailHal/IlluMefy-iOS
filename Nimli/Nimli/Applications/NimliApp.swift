//
//  NimliApp.swift
//  Nimli
//
//  Created by Haruto K. on 2025/02/09.
//

import SwiftUI
import SwiftData
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    #if DEBUG
      if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" {
          FirebaseApp.configure()
      }
    #else
      FirebaseApp.configure()
    #endif
    return true
  }
}

@main
struct NimliApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var router = NimliAppRouter()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(router)
        }
    }
}
