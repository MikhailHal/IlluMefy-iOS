//
//  UserLocalSettingsDataSourceProtocol.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/04/03.
//

protocol UserLocalSettingsDataSourceProtocol {
    func getString(forKey key: UserLocalSettingsDataSourceKey, default: String) -> String
    func setString(_ value: String, forKey key: UserLocalSettingsDataSourceKey)
    func getBool(forKey key: UserLocalSettingsDataSourceKey) -> Bool
    func setBool(_ value: Bool, forKey key: UserLocalSettingsDataSourceKey)
    func remove(forKey key: UserLocalSettingsDataSourceKey)
}
