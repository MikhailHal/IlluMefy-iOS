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
    enum Destination: Hashable {
        case phoneNumberRegistration
        case login
        case groupList
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
}
