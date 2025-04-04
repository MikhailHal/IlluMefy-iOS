//
//  ContentView.swift
//  Nimli
//
//  Created by Haruto K. on 2025/02/09.
//  Test

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var router: NimliAppRouter
    @StateObject private var loginViewModel = DependencyContainer.shared.resolve(LoginViewModel.self)!
    
    var body: some View {
        ZStack {
            NavigationStack(path: $router.path) {
                Group {
                    if loginViewModel.hasStoredLoginInfo {
                        LoginView()
                    } else {
                        SignUpView()
                    }
                }
                .navigationDestination(for: NimliAppRouter.Destination.self) { destination in
                    switch destination {
                    case .signUp:
                        SignUpView()
                    case .emailVerification:
                        VerificationEmailView()
                    case .login:
                        LoginView()
                    case .groupList:
                        GroupListView()
                    }
                }
            }.environmentObject(router)
            if router.isShowingLoadingIndicator {
                NimliLoadingDialog(isLoading: true, message: router.loadingMessage)
            }
        }
        .onAppear {
            Task {
                await loginViewModel.initializeStoedLoginAccountData()
            }
        }
    }
}
