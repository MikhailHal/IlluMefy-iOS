//
//  HomeBaseView.swift
//  Nimli
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
        appearance.backgroundColor = UIColor.screenBackground
        appearance.titleTextAttributes = [
            .font: UIFont.preferredFont(forTextStyle: .title3),
            .foregroundColor: UIColor.textForeground
        ]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        VStack {
            TabBarView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.screenBackground)
                .navigationTitle("ホーム画面")
                .navigationBarTitleDisplayMode(.inline)
                .ignoresSafeArea(.keyboard, edges: .all)
                .navigationBarBackButtonHidden()
        }.background(.screenBackground)
    }
}

private struct TabBarView: View {
    init() {
        let appearance: UITabBarAppearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = .tabBackground
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().standardAppearance = appearance
    }
    var body: some View {
        TabView {
            GroupListView()
                .tabItem {
                    Image(systemName: "fork.knife")
                    Text("食材一覧")
                }
            SignUpView()
                .tabItem {
                    Image(systemName: "plus.app.fill")
                    Text("食材追加")
                }
            GroupListView()
                .tabItem {
                    Image(systemName: "person.crop.circle.fill.badge.plus")
                    Text("グループ")
                }
            LoginView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("設定")
                }
        }.accentColor(.tabAccent)
    }
}
#Preview {
    HomeBaseView {
    }
}
