//
//  UserLocalSettingsDataSource.swift
//  Nimli
//
//  Created by Haruto K. on 2025/04/03.
//

import Foundation
class UserLocalSettingsDataSource: UserLocalSettingsDataSourceProtocol {
    private let userDefaults = UserDefaults.standard
    func getString(forKey key: UserLocalSettingsDataSourceKey, default: String) -> String {
        return userDefaults.string(forKey: key.rawValue) ?? `default`
    }
    
    func setString(_ value: String, forKey key: UserLocalSettingsDataSourceKey) {
        userDefaults.set(value, forKey: key.rawValue)
    }
    
    func getBool(forKey key: UserLocalSettingsDataSourceKey) -> Bool {
        return userDefaults.bool(forKey: key.rawValue)
    }
    
    func setBool(_ value: Bool, forKey key: UserLocalSettingsDataSourceKey) {
        userDefaults.set(value, forKey: key.rawValue)
    }
    
    func remove(forKey key: UserLocalSettingsDataSourceKey) {
        userDefaults.removeObject(forKey: key.rawValue)
    }
}
