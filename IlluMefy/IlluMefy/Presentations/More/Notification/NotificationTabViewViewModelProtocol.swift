//
//  AnnouncementTabViewViewModelProtocol.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/08/21.
//
@MainActor
protocol NotificationTabViewViewModelProtocol {
    /// お知らせ取得処理
    func getNotification() async throws -> String
}
