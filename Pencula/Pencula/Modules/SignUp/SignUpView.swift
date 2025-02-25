//
//  SignUpView.swift
//  Pencula
//
//  Created by はると on 2025/02/12.
//

import SwiftUI

struct SignUpView: View {
    @State var name = ""
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [
            .font: UIFont.preferredFont(forTextStyle: .largeTitle)
        ]
        UINavigationBar.appearance().standardAppearance = appearance
    }
    var body: some View {
        NavigationView {
            VStack {
                Image("SignUpRegisteringAccountStep")
                    .padding(
                        EdgeInsets(
                            top: Spacing.xl,
                            leading: Spacing.none,
                            bottom: Spacing.none,
                            trailing: Spacing.none
                        )
                    )
                Text("受信可能なメールアドレスを入力してください。\n入力されたメールアドレスに認証番号を送信します。")
                    .foregroundColor(Color.textForeground)
                    .padding(EdgeInsets(
                        top: Spacing.xxxl,
                        leading: Spacing.none,
                        bottom: Spacing.none,
                        trailing: Spacing.none
                    )
                )
                PenculaPlainTextField(text: $name, title: "メールアドレス", placeHolder: "メールアドレスを入力してください。")
                Spacer()
                //test
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.screenBackground)
            .navigationTitle("会員登録")
            .navigationBarTitleDisplayMode(.inline)
        }
        .padding(Spacing.md)
        .background(Color.screenBackground)
    }
}

#Preview {
    SignUpView()
}
