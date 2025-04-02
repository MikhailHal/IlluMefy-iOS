//
//  UserPreferencesRepositoryProtocol.swift
//  Nimli
//
//  Created by Haruto K. on 2025/04/03.
//

protocol UserPreferencesRepositoryProtocol {
    var userLocalSettingsDataSource: any UserLocalSettingsDataSourceProtocol { get set }
    var isStoreLoginInfo: Bool { get set }
    var loginEmail: String { get set }
    var loginPassowrd: String { get set }
}
