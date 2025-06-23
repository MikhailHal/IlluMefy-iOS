//
//  HomeBaseView.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/04/08.
//

import SwiftUI

struct HomeBaseView<ContentView: View>: View {
    let content: ContentView
    @EnvironmentObject private var router: IlluMefyAppRouter
    
    init(@ViewBuilder content: () -> ContentView) {
        self.content = content()
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            VStack {
                TabBarView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Asset.Color.Application.Background.backgroundPrimary.swiftUIColor)
                    .ignoresSafeArea(.keyboard, edges: .all)
                    .navigationBarBackButtonHidden()
            }
            .navigationDestination(for: IlluMefyAppRouter.Destination.self) { destination in
                switch destination {
                case .phoneNumberRegistration:
                    PhoneNumberRegistrationView()
                case .groupList:
                    EmptyView() // Placeholder for future implementation
                case .phoneVerification(let verificationID, let phoneNumber):
                    PhoneVerificationView(verificationID: verificationID, phoneNumber: phoneNumber)
                case .creatorDetail(let creatorId):
                    CreatorDetailView(creatorId: creatorId)
                }
            }
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
