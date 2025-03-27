//
//  NimliAppRouter.swift
//  Nimli
//
//  Created by Haruto K. on 2025/03/27.
//

import Combine
import SwiftUI

class NimliAppRouter: ObservableObject {
    @Published var path = NavigationPath()
    @Published var isShowingLoadingIndicator = false
    @Published var loadingMessage: String?
    enum Destination: Hashable {
        case signUp
        case emailVerification
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
