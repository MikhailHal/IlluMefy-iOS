//
//  FirebaseRemoteConfigProtocol.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/08/22.
//

protocol FirebaseRemoteConfigProtocol {
    func fetchValue<T>(key: String)-> T?
}
