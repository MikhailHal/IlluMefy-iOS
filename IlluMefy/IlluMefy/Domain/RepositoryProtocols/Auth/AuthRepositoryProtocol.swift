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
    
    /// 現在の認証状態を取得
    func isAuthenticated() async -> Bool
    
    /// ログアウト
    func logout() async throws
    
    /// アカウント削除
    func deleteAccount() async throws
}