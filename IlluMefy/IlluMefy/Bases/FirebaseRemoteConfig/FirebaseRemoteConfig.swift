//
//  FirebaseRemoteConfig.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/08/22.
//

import FirebaseRemoteConfig

class FirebaseRemoteConfig: FirebaseRemoteConfigProtocol {
    private let remoteConfig = RemoteConfig.remoteConfig()
    
    init() {
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0  // 開発時はキャッシュ無効
        remoteConfig.configSettings = settings
        
        // 初期化
        Task {
            do {
                try await remoteConfig.fetchAndActivate()
            } catch {
                print("Remote Config: Failed to fetch - \(error)")
            }
        }
    }
    
    func fetchValue<T>(key: String) -> T? {
        let configValue = remoteConfig.configValue(forKey: key)
        
        switch T.self {
        case is String.Type:
            return configValue.stringValue as? T
        case is Int.Type:
            return configValue.numberValue.intValue as? T
        case is Double.Type:
            return configValue.numberValue.doubleValue as? T
        case is Bool.Type:
            return configValue.boolValue as? T
        case is Data.Type:
            return configValue.dataValue as? T
        default:
            return nil
        }
    }
}
