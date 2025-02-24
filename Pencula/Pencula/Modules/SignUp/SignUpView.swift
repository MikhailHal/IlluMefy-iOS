//
//  SignUpView.swift
//  Pencula
//
//  Created by はると on 2025/02/12.
//

import SwiftUI

struct SignUpView: View {
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
                Spacer()
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
