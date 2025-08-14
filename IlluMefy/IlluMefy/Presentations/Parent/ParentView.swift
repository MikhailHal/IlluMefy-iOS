//
//  ParentView.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/02/09.
//  Test

import SwiftUI
import SwiftData
import FirebaseAuth

struct ParentView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var router: IlluMefyAppRouter
    @State private var isCheckingAuth = true
    @State private var isAuthenticated = false
    @State private var authStateHandle: AuthStateDidChangeListenerHandle?
    
    var body: some View {
        ZStack {
            NavigationStack(path: $router.path) {
                Group {
                    if isAuthenticated {
                        // 認証済みユーザーはホーム画面へ
                        HomeBaseView()
                    } else {
                        // 未認証ユーザーは電話番号認証画面へ
                        PhoneNumberRegistrationView()
                    }
                }
                .navigationDestination(for: IlluMefyAppRouter.Destination.self) { destination in
                    switch destination {
                    case .home:
                        HomeBaseView()
                    case .phoneNumberRegistration:
                        PhoneNumberRegistrationView()
                    case .phoneVerification(let verificationID, let phoneNumber):
                        PhoneVerificationView(verificationID: verificationID, phoneNumber: phoneNumber)
                    case .creatorDetail(let creator):
                        CreatorDetailView(creator: creator)
                    }
                }
            }.environmentObject(router)
            if router.isShowingLoadingIndicator {
                IlluMefyLoadingDialog(isLoading: true, message: router.loadingMessage)
            }
            if router.isShowingConfirmationDialog {
                if let params = router.confirmationDialogParams {
                    IlluMefyConfirmationDialog(
                        title: params.title,
                        message: params.message,
                        onClickOk: params.onClickOk,
                        onClickCancel: params.onClickCancel
                    )
                }
            }
        }
        .onAppear {
            setupAuthStateListener()
        }
        .onDisappear {
            if let handle = authStateHandle {
                Auth.auth().removeStateDidChangeListener(handle)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("AuthenticationStatusChanged"))) { _ in
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                checkAuthenticationStatus()
            }
        }
    }
    
    private func checkAuthenticationStatus() {
        // テスト環境またはプレビュー環境では認証チェックをスキップ
        guard ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil &&
              ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" else {
            isAuthenticated = false
            isCheckingAuth = false
            return
        }
        
        // Firebase Authの現在のユーザーをチェック
        if Auth.auth().currentUser != nil {
            // ユーザーが存在する場合は認証済みとみなす
            isAuthenticated = true
        } else {
            isAuthenticated = false
        }
        isCheckingAuth = false
    }
    
    private func setupAuthStateListener() {
          // テスト環境またはプレビュー環境では認証リスナーをスキップ
          guard ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil &&
      ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1"
      else {
              isAuthenticated = false
              isCheckingAuth = false
              return
          }

          // Firebase Authの状態変更リスナーを設定
          authStateHandle = Auth.auth().addStateDidChangeListener { _, user in
              DispatchQueue.main.async {
                  if user != nil {
                      isAuthenticated = true
                  } else {
                      isAuthenticated = false
                  }
                  isCheckingAuth = false
              }
          }
      }
}

#Preview {
    ParentView()
    .environmentObject(IlluMefyAppRouter())
}
