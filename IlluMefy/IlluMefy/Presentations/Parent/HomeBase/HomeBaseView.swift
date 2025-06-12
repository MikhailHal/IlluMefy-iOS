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
    }
    
    var body: some View {
        VStack {
            TabBarView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Asset.Color.Application.Background.background.swiftUIColor)
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
                    Text(L10n.Navigation.home)
                }
            FavoriteView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text(L10n.Navigation.favorite)
                }
            SearchView()
                .tabItem {
                    Image(systemName: "sparkle.magnifyingglass")
                    Text(L10n.Navigation.search)
                }
            AccountView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text(L10n.Navigation.account)
                }
            SettingView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text(L10n.Navigation.settings)
                }
        }
    }
}
#Preview {
    HomeBaseView {
        Text(L10n.Common.previewContent)
    }
    .environmentObject(IlluMefyAppRouter())
}
