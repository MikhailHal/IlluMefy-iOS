//
//  ParentView.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/02/09.
//  Test

import SwiftUI
import SwiftData

struct ParentView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var router: IlluMefyAppRouter
    
    var body: some View {
        ZStack {
            NavigationStack(path: $router.path) {
                // 統一フローにより、常に電話番号認証画面から開始
                PhoneNumberRegistrationView()
                .navigationDestination(for: IlluMefyAppRouter.Destination.self) { destination in
                    switch destination {
                    case .phoneNumberRegistration:
                        PhoneNumberRegistrationView()
                    case .groupList:
                        HomeBaseView {
                            Text("Hello World")
                        }
                    case .phoneVerification(let verificationID, let phoneNumber):
                        PhoneVerificationView(verificationID: verificationID, phoneNumber: phoneNumber)
                    }
                }
            }.environmentObject(router)
            if router.isShowingLoadingIndicator {
                IlluMefyLoadingDialog(isLoading: true, message: router.loadingMessage)
            }
        }
    }
}
