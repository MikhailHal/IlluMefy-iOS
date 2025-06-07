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
        appearance.backgroundColor = Asset.Color.Application.Background.background.color
        appearance.titleTextAttributes = [
            .font: UIFont.preferredFont(forTextStyle: .title3),
            .foregroundColor: Asset.Color.Application.foreground.color
        ]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        VStack {
            TabBarView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Asset.Color.Application.Background.background.swiftUIColor)
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
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("ホーム")
                }
            FavoriteView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("お気に入り")
                }
            SearchView()
                .tabItem {
                    Image(systemName: "sparkle.magnifyingglass")
                    Text("検索")
                }
            AccountView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("アカウント")
                }
            SettingView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("設定")
                }
        }
    }
}
#Preview {
    HomeBaseView {
        Text("Preview Content")
    }
    .environmentObject(IlluMefyAppRouter())
}
