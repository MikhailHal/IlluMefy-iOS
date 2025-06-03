//
//  UserPreferencesRepositoryProtocol.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/04/03.
//

protocol UserPreferencesRepositoryProtocol: Sendable {
    var userLocalSettingsDataSource: any UserLocalSettingsDataSourceProtocol { get }
    var isStoreLoginInfo: Bool { get set }
    var loginEmail: String { get set }
    var loginPassowrd: String { get set }
}
