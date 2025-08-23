//
//  NotificationTabViewViewModel.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/08/21.
//
import Foundation

@MainActor
@Observable
final class NotificationTabViewViewModel: NotificationTabViewViewModelProtocol {
    private var getOfficialNotificationUseCase: GetOfficialNotificationUseCaseProtocol
    
    init(getOfficialNotificationUseCase: GetOfficialNotificationUseCaseProtocol) {
        self.getOfficialNotificationUseCase = getOfficialNotificationUseCase
    }
    func getNotification() async throws -> String {
        do {
            let notification = try await getOfficialNotificationUseCase.fetchOfficialNotification()
            if notification.content.isEmpty {
                return "お知らせはありません"
            } else {
                return notification.content
            }
        } catch {
            return "お知らせはありません"
        }
    }
    
}
