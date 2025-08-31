//
//  AppConfig.swift
//  IlluMefy
//
//  Created by Claude on 2025/08/31.
//

import Foundation

/// アプリケーション設定管理
final class AppConfig {
    
    // MARK: - Singleton
    static let shared = AppConfig()
    
    // MARK: - Properties
    private let apiBaseURL: String
    private let projectId: String
    private let bundleId: String
    
    // MARK: - Computed Properties
    var baseURL: String {
        return apiBaseURL
    }
    
    var firebaseProjectId: String {
        return projectId
    }
    
    var appBundleId: String {
        return bundleId
    }
    
    var isDebugMode: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    var environmentName: String {
        #if DEBUG
        return "Development"
        #else
        return "Production"
        #endif
    }
    
    // MARK: - Initialization
    private init() {
        // GoogleService-Info.plistから設定を読み込み
        guard let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: path) else {
            fatalError("❌ [AppConfig] GoogleService-Info.plist not found")
        }
        
        // API Base URL
        guard let apiURL = plist["API_BASE_URL"] as? String else {
            fatalError("❌ [AppConfig] API_BASE_URL not found in GoogleService-Info.plist")
        }
        self.apiBaseURL = apiURL
        
        // Project ID
        guard let projectId = plist["PROJECT_ID"] as? String else {
            fatalError("❌ [AppConfig] PROJECT_ID not found in GoogleService-Info.plist")
        }
        self.projectId = projectId
        
        // Bundle ID
        guard let bundleId = plist["BUNDLE_ID"] as? String else {
            fatalError("❌ [AppConfig] BUNDLE_ID not found in GoogleService-Info.plist")
        }
        self.bundleId = bundleId
        
        // ログ出力（デバッグ時のみ）
        if isDebugMode {
            print("🔧 [AppConfig] Initialized with environment: \(environmentName)")
            print("🔧 [AppConfig] API Base URL: \(apiBaseURL)")
            print("🔧 [AppConfig] Project ID: \(projectId)")
            print("🔧 [AppConfig] Bundle ID: \(bundleId)")
        }
    }
}

// MARK: - Additional Configurations
extension AppConfig {
    
    /// APIタイムアウト（秒）
    var apiTimeout: TimeInterval {
        return isDebugMode ? 60.0 : 30.0
    }
    
    /// 最大リトライ回数
    var maxRetryCount: Int {
        return 3
    }
    
    /// ログ出力有効/無効
    var isLoggingEnabled: Bool {
        return isDebugMode
    }
    
    /// キャッシュ有効期限（秒）
    var cacheExpiration: TimeInterval {
        return isDebugMode ? 60.0 : 3600.0  // Debug: 1分, Production: 1時間
    }
}