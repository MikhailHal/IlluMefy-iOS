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
    var body: some View {
        ZStack {
            NavigationStack(path: $router.path) {
                SignUpView()
                    .navigationDestination(for: NimliAppRouter.Destination.self) { destination in
                        switch destination {
                        case .signUp:
                            SignUpView()
                        case .emailVerification:
                            VerificationEmailView()
                        }
                    }
            }.environmentObject(router)
            if router.isShowingLoadingIndicator {
                NimliLoadingDialog(isLoading: true, message: router.loadingMessage)
            }
        }
    }
}
