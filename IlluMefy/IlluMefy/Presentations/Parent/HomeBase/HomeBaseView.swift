//
//  HomeBaseView.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/04/08.
//

import SwiftUI

struct HomeBaseView: View {
    @EnvironmentObject private var router: IlluMefyAppRouter
    
    var body: some View {
        VStack {
            TabBarView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Asset.Color.Application.Background.backgroundPrimary.swiftUIColor)
                .ignoresSafeArea(.keyboard, edges: .all)
                .navigationBarBackButtonHidden()
        }
    }
}

private struct TabBarView: View {
    @State private var selectedTab: Int = 0
    @StateObject private var searchViewModel = DependencyContainer.shared.resolve(SearchViewModel.self)!
    
    init() {
        let appearance: UITabBarAppearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().standardAppearance = appearance
    }
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(onTagTapped: { tag in
                selectedTab = 2 // Switch to search tab
                searchViewModel.searchWithTag(tag)
            })
                .tabItem {
                    Image(systemName: "house.fill")
                    Text(L10n.Navigation.home)
                }
                .tag(0)
            FavoriteView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text(L10n.Navigation.favorite)
                }
                .tag(1)
            SearchView(viewModel: searchViewModel)
                .tabItem {
                    Image(systemName: "sparkle.magnifyingglass")
                    Text(L10n.Navigation.search)
                }
                .tag(2)
            AccountView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text(L10n.Navigation.account)
                }
                .tag(3)
            SettingView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text(L10n.Navigation.settings)
                }
                .tag(4)
        }
    }
}
#Preview {
    HomeBaseView()
        .environmentObject(IlluMefyAppRouter())
}
