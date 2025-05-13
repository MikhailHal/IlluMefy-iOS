//
//  ContentView.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/02/09.
//  Test

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var router: IlluMefyAppRouter
    @StateObject private var loginViewModel = DependencyContainer.shared.resolve(LoginViewModel.self)!
    
    var body: some View {
        ZStack {
            NavigationStack(path: $router.path) {
                Group {
                    if loginViewModel.hasStoredLoginInfo {
                        LoginView()
                    } else {
                        PhoneNumberRegistrationView()
                    }
                }
                .navigationDestination(for: IlluMefyAppRouter.Destination.self) { destination in
                    switch destination {
                    case .phoneNumberRegistration:
                        PhoneNumberRegistrationView()
                    case .login:
                        LoginView()
                    case .groupList:
                        HomeBaseView {
                            Text("Hello World")
                        }
                    }
                }
            }.environmentObject(router)
            if router.isShowingLoadingIndicator {
                IlluMefyLoadingDialog(isLoading: true, message: router.loadingMessage)
            }
        }
        .onAppear {
            Task {
                await loginViewModel.initializeStoedLoginAccountData()
            }
        }
    }
}
