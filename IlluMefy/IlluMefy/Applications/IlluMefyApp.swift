//
//  IlluMefyApp.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/02/09.
//

import SwiftUI
import SwiftData
import FirebaseCore
import FirebaseAuth
import UserNotifications
import FirebaseAppCheck

class IlluMefyAppCheckProviderFactory: NSObject, AppCheckProviderFactory {
  func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
    #if DEBUG
    return AppCheckDebugProvider(app: app)
    #else
    return AppAttestProvider(app: app)
    #endif
  }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  /// アプリ起動時
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    // デバッグ時は初期化処理は行わない
    if isDebugOrPreviewMode() {
        return true
    }
    
    // App Check設定（Firebase初期化後）
    setupAppCheck()
      
    // Firebase初期化
    FirebaseApp.configure()
    
    // APNs通知設定
    UNUserNotificationCenter.current().delegate = self
    // プッシュ通知受信許可
    application.registerForRemoteNotifications()
    return true
  }
  
  // APNsからトークンを受信
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Auth.auth().setAPNSToken(deviceToken, type: .unknown)
  }
  
  // サイレントプッシュ通知を受信
  func application(_ application: UIApplication,
                   didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                   fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    _ = Auth.auth().canHandleNotification(userInfo)
    completionHandler(.noData)
  }
    
  /// デバッグやプレビューモードかどうかの判定
  /// - Returns true: デバッグ状態
  /// - Returns false: 非デバッグ状態
  private func isDebugOrPreviewMode() -> Bool {
      return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" ||
      ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
  }
  
  /// AppCheckの初期化
  ///
  /// DEBUGモード時はデバッグファクトリを用いて、実行時は実際のトークンを使用する
  private func setupAppCheck() {
    let providerFactory = IlluMefyAppCheckProviderFactory()
    AppCheck.setAppCheckProviderFactory(providerFactory)
  }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
  /// プッシュ通知受信
  nonisolated func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([])
  }
  
  /// プッシュ通知押下
  nonisolated func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void) {
    completionHandler()
  }
}

@main
struct IlluMefyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var router = IlluMefyAppRouter()
    var body: some Scene {
        WindowGroup {
            ParentView().environmentObject(router)
        }
    }
}
