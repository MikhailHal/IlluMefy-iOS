//
//  IlluMefyAppRouter.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/03/27.
//

import Combine
import SwiftUI

class IlluMefyAppRouter: ObservableObject {
    @Published var path = NavigationPath()
    @Published var isShowingLoadingIndicator = false
    @Published var loadingMessage: String?
    @Published var isShowingConfirmationDialog: Bool = false
    var confirmationDialogParams: IlluMefyConfirmationDialogParams?
    enum Destination: Hashable {
        case phoneNumberRegistration
        case home
        case phoneVerification(verificationID: String, phoneNumber: String)
        case creatorDetail(creator: Creator)
        case search(tag: Tag)
    }
    func navigate(to destination: Destination) {
        path.append(destination)
    }
    func navigateBack() {
        path.removeLast()
    }
    func navigateToRoot() {
        path = NavigationPath()
    }
    func showLoading(message: String? = nil) {
        loadingMessage = message
        isShowingLoadingIndicator = true
    }
    func hideLoading() {
        isShowingLoadingIndicator = false
    }
    
    func showConfirmationDialog(
        title: String,
        message: String,
        onClickOk: @escaping () -> Void,
        onClickCancel: @escaping () -> Void
    ) {
        isShowingConfirmationDialog = true
        let wrappedOnClickOk: () -> Void = {
            onClickOk()
            self.isShowingConfirmationDialog = false
        }
        let wrappedOnClickCancel: () -> Void = {
            onClickCancel()
            self.isShowingConfirmationDialog = false
        }
        confirmationDialogParams = IlluMefyConfirmationDialogParams(
            title: title,
            message: message,
            onClickOk: wrappedOnClickOk,
            onClickCancel: wrappedOnClickCancel
        )
    }
}
