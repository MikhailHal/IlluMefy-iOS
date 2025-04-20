//
//  LoginView.swift
//  Nimli
//
//  Created by Haruto K. on 2025/04/02.
//

import SwiftUI

// カスタムテキストフィールドスタイル
struct LoginTextFieldStyle: TextFieldStyle {
    @FocusState private var isFocused: Bool
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .focused($isFocused)
            .padding(.vertical, 14)
            .padding(.horizontal, 16)
            .background(Color("Background/Card"))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        isFocused ? Color("Base/Main") : Color("TextBorderNoneFocused"),
                        lineWidth: isFocused ? 1.5 : 0.5
                    )
            )
    }
}

// ボタンスタイルの定義
struct NimliLoginButtonStyle: ButtonStyle {
    let isValid: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(isValid ? 1.0 : 0.6)
            .shadow(
                color: Color("Base/Main").opacity(configuration.isPressed ? 0.1 : 0.2),
                radius: configuration.isPressed ? 4 : 8,
                y: configuration.isPressed ? 2 : 4
            )
            .animation(.spring(response: 0.2), value: configuration.isPressed)
    }
}

struct LoginView: View {
    @StateObject private var viewModel = DependencyContainer.shared.resolve(LoginViewModel.self)!
    @EnvironmentObject var router: NimliAppRouter
    
    var body: some View {
        ScrollView {
            VStack {
                // Welcome Section
                VStack(spacing: Spacing.componentGrouping) {
                    Image(systemName: "lock.shield.fill")
                        .font(.system(size: 48))
                        .foregroundColor(Color("Base/Main"))
                    Text("おかえりなさい！")
                        .font(.subheadline)
                        .foregroundColor(Color("Text/Foreground"))
                    Text("フードロスを減らしていきましょう！")
                        .font(.subheadline)
                        .foregroundColor(Color("Text/Foreground"))
                }
                .padding(.top, Spacing.screenEdgePadding)
                .padding(.bottom, Spacing.unrelatedComponentDivider)
                
                // Login Form Card
                NimliCardNomal(content: {
                    VStack(spacing: Spacing.unrelatedComponentDivider) {
                        LoginForm(viewModel: viewModel)
                        
                        // Store login info
                        Toggle(isOn: $viewModel.isStoreLoginInformation) {
                            Text("ログイン情報を保存する")
                                .font(.footnote)
                                .foregroundColor(Color("Text/OnCard"))
                        }
                        .toggleStyle(SwitchToggleStyle(tint: Color("ToggleButton/Enabled")))
                    }
                    .padding(.vertical, 8)
                })
                .padding(.horizontal, Spacing.screenEdgePadding)
                
                // Login Button
                NimliButton(
                    title: "ログイン",
                    isEnabled: viewModel.isValid,
                    action: {
                        Task {
                            router.showLoading()
                            await viewModel.login()
                            router.hideLoading()
                        }
                    }
                ).padding(.horizontal, Spacing.screenEdgePadding)
                Spacer()
            }
        }
        .background(Color("Background/Screen"))
        .alert("ログイン失敗", isPresented: $viewModel.isShowErrorDialog) {
            Button("OK") { viewModel.isShowErrorDialog = false }
        } message: {
            Text(viewModel.errorDialogMessage)
        }
        .alert("ログイン成功", isPresented: $viewModel.isShowNotificationDialog) {
            Button("OK") {
                viewModel.isShowNotificationDialog = false
                router.navigate(to: .groupList)
            }
        } message: {
            Text(viewModel.notificationDialogMessage)
        }
        .onAppear {
            Task {
                await viewModel.initializeStoedLoginAccountData()
            }
        }
    }
}

struct LoginForm: View {
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            // Email field
            VStack(alignment: .leading, spacing: 8) {
                Text("メールアドレス")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(Color("Text/OnCard"))
                
                TextField("メールアドレスを入力", text: $viewModel.email)
                    .textFieldStyle(LoginTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .foregroundColor(Color("Text/OnCard"))
            }
            
            // Password field
            VStack(alignment: .leading, spacing: 8) {
                Text("パスワード")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(Color("Text/OnCard"))
                
                SecureField("パスワードを入力", text: $viewModel.password)
                    .textFieldStyle(LoginTextFieldStyle())
                    .textContentType(.password)
                    .foregroundColor(Color("Text/OnCard"))
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(NimliAppRouter())
}
