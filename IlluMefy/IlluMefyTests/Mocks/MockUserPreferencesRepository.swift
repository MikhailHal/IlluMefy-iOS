//
//  MockUserPreferencesRepository.swift
//  IlluMefyTests
//
//  Created by Haruto K. on 2025/06/01.
//

import Foundation
@testable import IlluMefy

final class MockUserPreferencesRepository: UserPreferencesRepositoryProtocol, @unchecked Sendable {
    
    // プロトコル要求
    let userLocalSettingsDataSource: any UserLocalSettingsDataSourceProtocol
    var isStoreLoginInfo: Bool = false
    var loginEmail: String = ""
    var loginPassowrd: String = ""
    
    // テスト用のプロパティ
    var saveWasCalled = false
    var loadWasCalled = false
    var removeWasCalled = false
    var removeAllWasCalled = false
    
    var savedKey: String?
    var savedValue: Any?
    var loadedKey: String?
    var removedKey: String?
    
    // エラーを設定
    var saveError: Error?
    var loadError: Error?
    var removeError: Error?
    var removeAllError: Error?
    
    // load時の返却値
    var loadReturnValue: Any?
    
    init() {
        self.userLocalSettingsDataSource = MockUserLocalSettingsDataSource()
    }
    
    
    func save(key: String, value: any Codable) throws {
        saveWasCalled = true
        savedKey = key
        savedValue = value
        
        if let error = saveError {
            throw error
        }
    }
    
    func load<T: Codable>(key: String, type: T.Type) throws -> T? {
        loadWasCalled = true
        loadedKey = key
        
        if let error = loadError {
            throw error
        }
        
        return loadReturnValue as? T
    }
    
    func remove(key: String) throws {
        removeWasCalled = true
        removedKey = key
        
        if let error = removeError {
            throw error
        }
    }
    
    func removeAll() throws {
        removeAllWasCalled = true
        
        if let error = removeAllError {
            throw error
        }
    }
}

// MockUserLocalSettingsDataSourceも必要
final class MockUserLocalSettingsDataSource: UserLocalSettingsDataSourceProtocol, @unchecked Sendable {
    private var storage: [String: Any] = [:]
    
    func getString(forKey key: UserLocalSettingsDataSourceKey, default defaultValue: String) -> String {
        return storage[key.rawValue] as? String ?? defaultValue
    }
    
    func setString(_ value: String, forKey key: UserLocalSettingsDataSourceKey) {
        storage[key.rawValue] = value
    }
    
    func getBool(forKey key: UserLocalSettingsDataSourceKey) -> Bool {
        return storage[key.rawValue] as? Bool ?? false
    }
    
    func setBool(_ value: Bool, forKey key: UserLocalSettingsDataSourceKey) {
        storage[key.rawValue] = value
    }
    
    func remove(forKey key: UserLocalSettingsDataSourceKey) {
        storage.removeValue(forKey: key.rawValue)
    }
}