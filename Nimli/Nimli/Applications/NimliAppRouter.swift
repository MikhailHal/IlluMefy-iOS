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
}
