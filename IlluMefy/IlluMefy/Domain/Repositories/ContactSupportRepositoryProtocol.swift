//
//  ContactSupportRepositoryProtocol.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/27.
//

import Foundation

protocol ContactSupportRepositoryProtocol {
    /// お問い合わせを送信する
    /// - Parameter request: お問い合わせリクエスト
    /// - Returns: 送信されたお問い合わせ
    /// - Throws: ContactSupportError
    func submitContactSupport(_ request: ContactSupportRequest) async throws -> ContactSupport
    
    /// ユーザーのお問い合わせ履歴を取得する
    /// - Parameter userId: ユーザーID
    /// - Returns: お問い合わせ履歴の配列
    /// - Throws: ContactSupportError
    func getContactSupportHistory(userId: String) async throws -> [ContactSupport]
    
    /// 特定のお問い合わせを取得する
    /// - Parameter id: お問い合わせID
    /// - Returns: お問い合わせ
    /// - Throws: ContactSupportError
    func getContactSupport(id: String) async throws -> ContactSupport
}