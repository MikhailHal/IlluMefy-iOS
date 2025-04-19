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
    
    private func configureNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.screenBackground
        appearance.titleTextAttributes = [
            .font: UIFont.preferredFont(forTextStyle: .title3),
            .foregroundColor: UIColor.textForeground
        ]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Header()
            
            ScrollView {
                VStack(spacing: Spacing.unrelatedComponentDivider) {
                    // ログインフォーム
                    VStack(spacing: Spacing.relatedComponentDivider) {
                        // メールアドレスフィールド
                        VStack(alignment: .leading, spacing: Spacing.componentGrouping) {
                            Text("メールアドレス")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(Color("Text/OnCard"))
                            
                            TextField("メールアドレスを入力", text: $viewModel.email)
                                .textFieldStyle(LoginTextFieldStyle())
                                .autocapitalization(.none)
                                .foregroundColor(Color("Text/OnCard"))
                        }
                        
                        // パスワードフィールド
                        VStack(alignment: .leading, spacing: Spacing.componentGrouping) {
                            Text("パスワード")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(Color("Text/OnCard"))
                            
                            SecureField("パスワードを入力", text: $viewModel.password)
                                .textFieldStyle(LoginTextFieldStyle())
                                .foregroundColor(Color("Text/OnCard"))
                        }
                        
                        // ログイン情報保存オプション
                        Toggle(isOn: $viewModel.isStoreLoginInformation) {
                            Text("ログイン情報を保存する")
                                .font(.system(size: 14))
                                .foregroundColor(Color("Text/OnCard"))
                        }
                        .toggleStyle(SwitchToggleStyle(tint: Color("ToggleButton/Enabled")))
                    }
                    .padding(20)
                    .background(Color("Background/Card"))
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
                    
                    // ログインボタン
                    Button(action: {
                        Task {
                            router.showLoading()
                            await viewModel.login()
                            router.hideLoading()
                        }
                    }, label: {
                        Text("ログイン")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(Color("Text/OnMain"))
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Color("Base/Main"))
                            .cornerRadius(6)
                    })
                }
                .padding(.horizontal, Spacing.screenEdgePadding)
            }
            
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

#Preview {
    LoginView()
        .environmentObject(NimliAppRouter())
}
