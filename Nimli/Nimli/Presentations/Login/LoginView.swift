//
//  LoginView.swift
//  Nimli
//
//  Created by Haruto K. on 2025/04/02.
//

import SwiftUI

// カスタムテキストフィールドスタイル
struct LoginTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(Color("Background/Card"))
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color("TextBorderNoneFocused"), lineWidth: 0.5)
            )
    }
}

struct LoginView: View {
    @StateObject private var viewModel = DependencyContainer.shared.resolve(LoginViewModel.self)!
    @EnvironmentObject var router: NimliAppRouter
    
    var body: some View {
        VStack {
            Header()
            NimliCardNomal(content: {
                LoginForm(viewModel: viewModel)
                
                // option for storing login
                Toggle(isOn: $viewModel.isStoreLoginInformation) {
                    Text("ログイン情報を保存する")
                        .font(.system(size: 14))
                        .foregroundColor(Color("Text/OnCard"))
                }
                .toggleStyle(SwitchToggleStyle(tint: Color("ToggleButton/Enabled")))
            })
            .padding(Spacing.screenEdgePadding)
            Button(action: {
                Task {
                    router.showLoading()
                    await viewModel.login()
                    router.hideLoading()
                }
            }, label: {
                Text("ログイン")
                    .font(.system(size: 15, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .foregroundColor(Color("Text/OnMain"))
                    .background(viewModel.isValid ? Color("Base/Main") : Color("Base/Main").opacity(0.5))
                    .cornerRadius(6)
            })
            .disabled(!viewModel.isValid)
            .padding(.horizontal, Spacing.screenEdgePadding)
            Spacer()
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

private func Header() -> some View {
    HStack {
        Spacer()
        Text("LOG IN")
            .font(.system(size: 17, weight: .regular))
            .foregroundColor(Color("Text/Foreground"))
        Spacer()
    }
    .padding(Spacing.screenEdgePadding)
}

struct LoginForm: View {
    @ObservedObject var viewModel: LoginViewModel
    var body: some View {
        VStack {
            // Email field
            VStack(alignment: .leading, spacing: Spacing.componentGrouping) {
                Text("メールアドレス")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color("Text/OnCard"))
                
                TextField("メールアドレスを入力", text: $viewModel.email)
                    .textFieldStyle(LoginTextFieldStyle())
                    .autocapitalization(.none)
                    .foregroundColor(Color("Text/OnCard"))
            }
            
            // Password field
            VStack(alignment: .leading, spacing: Spacing.componentGrouping) {
                Text("パスワード")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color("Text/OnCard"))
                
                SecureField("パスワードを入力", text: $viewModel.password)
                    .textFieldStyle(LoginTextFieldStyle())
                    .foregroundColor(Color("Text/OnCard"))
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(NimliAppRouter())
}
