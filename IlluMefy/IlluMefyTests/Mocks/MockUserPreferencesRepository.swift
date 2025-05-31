//
//  MockUserPreferencesRepository.swift
//  IlluMefyTests
//
//  Created by Haruto K. on 2025/06/01.
//

import Foundation
@testable import IlluMefy

class MockUserPreferencesRepository: UserPreferencesRepositoryProtocol {
    // RepositorySyncProtocol要求
    typealias Request = Void
    typealias Response = Void
    typealias Error = UserPreferencesRepositoryError
    
    // プロトコル要求
    var userLocalSettingsDataSource: any UserLocalSettingsDataSourceProtocol
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
    
    // RepositorySyncProtocol要求
    func execute(request: Request) throws -> Response {
        // このメソッドはUserPreferencesRepositoryでは使用されない
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
class MockUserLocalSettingsDataSource: UserLocalSettingsDataSourceProtocol {
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