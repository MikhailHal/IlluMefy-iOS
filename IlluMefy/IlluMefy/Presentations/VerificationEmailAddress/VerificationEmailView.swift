//
//  VerificationEmailView.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/03/25.
//
//  MEMO:
//    DON'T USE.
//    This screen is WIP.
//

import SwiftUI

@MainActor
struct VerificationEmailView: View {
    @StateObject private var viewModel = DependencyContainer.shared.resolve(VerificationEmailAddressViewModel.self)!
    @EnvironmentObject var router: IlluMefyAppRouter
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        //appearance.backgroundColor = UIColor.screenBackground
        appearance.titleTextAttributes = [
            .font: UIFont.preferredFont(forTextStyle: .title3),
            //.foregroundColor: UIColor.textForeground
        ]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    var body: some View {
        ZStack {
            VStack {
                Text("STEP：2 / 3")
                    //.foregroundColor(Color.textForeground)
                    .bold()
                    .font(.title)
                Spacer()
                Text("メール内のリンクを押下してアプリを開いてください。")
                    //.foregroundColor(Color.textForeground)
                    .font(.title2)
                    .bold()
                Spacer()
            }
            .padding(Spacing.screenEdgePadding)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            //.background(Color.screenBackground)
            .navigationTitle("会員登録")
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea(.keyboard, edges: .all)
            .onAppear {
                Task {
                    router.showLoading()
                    if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != "1" {
                        let result = await viewModel.sendVerificationEmailLink()
                        await MainActor.run {
                            viewModel.dialogTitle = result.title
                            viewModel.dialogMessage = result.message
                            viewModel.isShowDialog = true
                        }
                    }
                    router.hideLoading()
                }
            }
            .alert(viewModel.dialogTitle, isPresented: $viewModel.isShowDialog) {
                Button("OK") { viewModel.isShowDialog = false }
            } message: {
                Text(viewModel.dialogMessage)
            }
        }
    }
}

#Preview {
    VerificationEmailView().environmentObject(IlluMefyAppRouter())
}
