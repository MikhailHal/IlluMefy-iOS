//
//  SignUpView.swift
//  Pencula
//
//  Created by はると on 2025/02/12.
//

import SwiftUI

struct SignUpView: View {
    @State var email = ""
    @State var password = ""
    init() {
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
        NavigationView {
            VStack {
                Text("STEP：1 / 3")
                    .foregroundColor(Color.textForeground)
                    .bold()
                    .font(.title)
                Text("受信可能なメールアドレスを入力してください。\n受信可能なものを指定してください。")
                    .foregroundColor(Color.textForeground)
                    .font(.body)
                    .padding(EdgeInsets(
                        top: Spacing.unrelatedComponentDivider,
                        leading: Spacing.none,
                        bottom: Spacing.none,
                        trailing: Spacing.none
                    )
                )
                PenculaPlainTextField(text: $email, title: "メールアドレス", placeHolder: "メールアドレスを入力")
                    .padding(EdgeInsets(
                        top: Spacing.unrelatedComponentDivider,
                        leading: Spacing.none,
                        bottom: Spacing.none,
                        trailing: Spacing.none))
                Text("メールが届きませんか？\nそういった場合は下記をご確認ください。")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color.textForegroundError)
                    .font(.body)
                    .bold()
                    .padding(EdgeInsets(
                        top: Spacing.componentGrouping,
                        leading: Spacing.none,
                        bottom: Spacing.none,
                        trailing: Spacing.none))
                Text("1. 迷惑メールに届いていないか\n" + "2. メールアドレスは正しいか\n" + "3. インターネットに接続されているか")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color.textForeground)
                    .font(.body)
                    .padding(EdgeInsets(
                        top: Spacing.componentGrouping,
                        leading: Spacing.none,
                        bottom: Spacing.none,
                        trailing: Spacing.none))
                PenculaButton(
                    eventType: PenculaButtonsOption.EventType.positive,
                    text: "認証コードを送信",
                    isEnabled: true,
                    onClick: {}
                ).padding(EdgeInsets(
                    top: Spacing.unrelatedComponentDivider,
                    leading: Spacing.none,
                    bottom: Spacing.none,
                    trailing: Spacing.none))
                Spacer()
            }
            .padding(Spacing.screenEdgePadding)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.screenBackground)
            .navigationTitle("会員登録")
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea(.keyboard, edges: .all)
        }
    }
}

#Preview {
    SignUpView()
}
