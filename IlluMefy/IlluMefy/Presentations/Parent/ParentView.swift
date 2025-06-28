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
                    // 認証状態チェック中
                    if isCheckingAuth {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.black.opacity(0.1))
                    } else if isAuthenticated {
                        // 認証済みユーザーは直接ホーム画面へ
                        HomeBaseView {
                            Text(L10n.Common.hello)
                        }
                    } else {
                        // 未認証ユーザーは電話番号認証画面へ
                        PhoneNumberRegistrationView()
                    }
                }
                .navigationDestination(for: IlluMefyAppRouter.Destination.self) { destination in
                    switch destination {
                    case .phoneNumberRegistration:
                        PhoneNumberRegistrationView()
                    case .groupList:
                        HomeBaseView {
                            Text(L10n.Common.hello)
                        }
                    case .phoneVerification(let verificationID, let phoneNumber):
                        PhoneVerificationView(verificationID: verificationID, phoneNumber: phoneNumber)
                    case .creatorDetail(let creatorId):
                        CreatorDetailView(creatorId: creatorId)
                    case .contactSupport:
                        ContactSupportView()
                    }
                }
            }.environmentObject(router)
            if router.isShowingLoadingIndicator {
                IlluMefyLoadingDialog(isLoading: true, message: router.loadingMessage)
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
            checkAuthenticationStatus()
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
        if let currentUser = Auth.auth().currentUser {
            // ユーザーが存在する場合は認証済みとみなす
            isAuthenticated = true
            print("User already authenticated: \(currentUser.uid)")
        } else {
            print("No authenticated user found")
            isAuthenticated = false
        }
        isCheckingAuth = false
    }
    
    private func setupAuthStateListener() {
        // テスト環境またはプレビュー環境では認証リスナーをスキップ
        guard ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil &&
              ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" else {
            isAuthenticated = false
            isCheckingAuth = false
            return
        }
        
        // Firebase Authの状態変更リスナーを設定
        authStateHandle = Auth.auth().addStateDidChangeListener { auth, user in
            DispatchQueue.main.async {
                if let user = user {
                    print("Auth state changed - User authenticated: \(user.uid)")
                    isAuthenticated = true
                } else {
                    print("Auth state changed - User not authenticated")
                    isAuthenticated = false
                }
                isCheckingAuth = false
            }
        }
    }
}
