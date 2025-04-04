//
//  UserPreferencesRepository.swift
//  Nimli
//
//  Created by Haruto K. on 2025/04/03.
//

import Foundation

class UserPreferencesRepository: UserPreferencesRepositoryProtocol {
    var userLocalSettingsDataSource: any UserLocalSettingsDataSourceProtocol
    typealias Request = Void
    typealias Response = Void
    typealias Error = UserPreferencesRepositoryError
    
    init(userLocalSettingsDataSource: UserLocalSettingsDataSourceProtocol) {
        self.userLocalSettingsDataSource = userLocalSettingsDataSource
    }
    
    var isStoreLoginInfo: Bool {
        get { userLocalSettingsDataSource.getBool(forKey: .isStoreLoginInfomation) }
        set { userLocalSettingsDataSource.setBool(newValue, forKey: .isStoreLoginInfomation) }
    }
    
    var loginEmail: String {
        get { userLocalSettingsDataSource.getString(forKey: .loginEmail, default: "") }
        set { userLocalSettingsDataSource.setString(newValue, forKey: .loginEmail) }
    }
    
    var loginPassowrd: String {
        get { userLocalSettingsDataSource.getString(forKey: .loginPassword, default: "") }
        set { userLocalSettingsDataSource.setString(newValue, forKey: .loginPassword) }
    }
    
    func execute(request: Request) throws -> Response {
        // 同期処理なので何もしない
        return
    }
}
