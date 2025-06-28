//
//  AuthRepositoryProtocol.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/28.
//

import Foundation

/// 認証リポジトリのプロトコル
protocol AuthRepositoryProtocol: Sendable {
    /// サインアウト
    func signOut() async throws
}