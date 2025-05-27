//
//  HomeBaseView.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/04/08.
//

import SwiftUI

struct HomeBaseView<ContentView: View>: View {
    let content: ContentView
    
    init(@ViewBuilder content: () -> ContentView) {
        self.content = content()
        configureNavigationBarAppearance()
    }
    
    private func configureNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.Application.background
        appearance.titleTextAttributes = [
            .font: UIFont.preferredFont(forTextStyle: .title3),
            .foregroundColor: Asset.Color.Application.foreground
        ]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        VStack {
            TabBarView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Asset.Color.Application.background.swiftUIColor)
                .navigationTitle("ホーム画面")
                .navigationBarTitleDisplayMode(.inline)
                .ignoresSafeArea(.keyboard, edges: .all)
                .navigationBarBackButtonHidden()
        }
    }
}

private struct TabBarView: View {
    init() {
        let appearance: UITabBarAppearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().standardAppearance = appearance
    }
    var body: some View {
        TabView {
            PhoneNumberRegistrationView()
                .tabItem {
                    Image(systemName: "fork.knife")
                    Text("食材一覧")
                }
            PhoneNumberRegistrationView()
                .tabItem {
                    Image(systemName: "plus.app.fill")
                    Text("食材追加")
                }
            GroupDetailView(viewModel: GroupDetailViewModel())
                .tabItem {
                    Image(systemName: "person.crop.circle.fill.badge.plus")
                    Text("グループ")
                }
            LoginView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("設定")
                }
        }
    }
}
#Preview {
    HomeBaseView(content: {}).environmentObject(IlluMefyAppRouter())
}
