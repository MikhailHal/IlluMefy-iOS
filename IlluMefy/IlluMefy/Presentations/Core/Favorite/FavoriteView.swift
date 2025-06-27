//
//  FavoriteView.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/08.
//

import SwiftUI

struct FavoriteView: View {
    @EnvironmentObject private var router: IlluMefyAppRouter
    @StateObject private var viewModel = DependencyContainer.shared.resolve(FavoriteViewModel.self)!
    
    var body: some View {
        ZStack {
            Asset.Color.Application.Background.backgroundPrimary.swiftUIColor
                .ignoresSafeArea()
            
            if viewModel.isLoading {
                loadingView
            } else if viewModel.favoriteCreators.isEmpty {
                emptyStateView
            } else {
                favoriteCreatorsView
            }
        }
        .navigationTitle(L10n.Favorite.title)
        .navigationBarTitleDisplayMode(.large)
        .task {
            await viewModel.loadFavoriteCreators()
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: Spacing.screenEdgePadding) {
            Image(systemName: "heart.slash")
                .font(.system(size: 64))
                .foregroundColor(Asset.Color.Application.textSecondary.swiftUIColor)
            
            Text(L10n.Favorite.emptyTitle)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(Asset.Color.Application.textPrimary.swiftUIColor)
            
            Text(L10n.Favorite.emptyMessage)
                .font(.body)
                .foregroundColor(Asset.Color.Application.textSecondary.swiftUIColor)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.screenEdgePadding)
        }
    }
    
    private var loadingView: some View {
        ProgressView()
            .scaleEffect(1.5)
            .tint(Asset.Color.Application.textPrimary.swiftUIColor)
    }
    
    private var favoriteCreatorsView: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 0),
                GridItem(.flexible(), spacing: 0),
                GridItem(.flexible(), spacing: 0)
            ], spacing: 0) {
                ForEach(viewModel.favoriteCreators) { creator in
                    FavoriteCreatorCard(creator: creator) {
                        router.navigate(to: .creatorDetail(creatorId: creator.id))
                    }
                }
            }
            .padding(0)
        }
    }
    
}

struct FavoriteCreatorCard: View {
    let creator: Creator
    let onTap: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            Button(action: onTap) {
                ZStack(alignment: .bottomLeading) {
                    // 背景画像（TikTok風の全面表示）
                    AsyncImage(url: URL(string: creator.thumbnailUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(Asset.Color.Application.Background.backgroundSecondary.swiftUIColor)
                            .overlay(
                                ProgressView()
                                    .tint(Asset.Color.Application.textSecondary.swiftUIColor)
                            )
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                    
                    // グラデーションオーバーレイ（テキストの可読性向上）
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.black.opacity(0.0),
                            Color.black.opacity(0.3),
                            Color.black.opacity(0.7)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    
                    // クリエイター情報（左下配置）
                    VStack(alignment: .leading, spacing: 4) {
                        Text(creator.name)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .shadow(radius: 1)
                        
                        let (platform, _) = creator.mainPlatform()
                        HStack(spacing: 4) {
                            if platform == .youtube {
                                Image(systemName: platform.icon)
                                    .font(.system(size: 10))
                                    .foregroundColor(.red)
                            } else {
                                Image(platform.icon)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 10, height: 10)
                            }
                            Text(platform.displayName)
                                .font(.system(size: 10))
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .shadow(radius: 1)
                    }
                    .padding(8)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .aspectRatio(9/16, contentMode: .fit) // TikTok風の縦長アスペクト比
    }
}

#Preview {
    FavoriteView()
}
