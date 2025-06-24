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
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: Spacing.relatedComponentDivider) {
                ForEach(viewModel.favoriteCreators) { creator in
                    FavoriteCreatorCard(creator: creator) {
                        router.navigate(to: .creatorDetail(creatorId: creator.id))
                    }
                }
            }
            .padding(Spacing.screenEdgePadding)
        }
    }
    
}

struct FavoriteCreatorCard: View {
    let creator: Creator
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: Spacing.componentGrouping) {
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
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                
                VStack(spacing: Spacing.componentGrouping) {
                    Text(creator.name)
                        .font(.system(size: Typography.bodyRegular, weight: .semibold))
                        .foregroundColor(Asset.Color.Application.textPrimary.swiftUIColor)
                        .lineLimit(1)
                    
                    let (platform, _) = creator.mainPlatform()
                    HStack(spacing: Spacing.componentGrouping) {
                        if platform == .youtube {
                            Image(systemName: platform.icon)
                                .font(.caption)
                                .foregroundColor(.red)
                        } else {
                            Image(platform.icon)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 12, height: 12)
                        }
                        Text(platform.displayName)
                            .font(.caption)
                            .foregroundColor(Asset.Color.Application.textSecondary.swiftUIColor)
                    }
                }
            }
            .padding(Spacing.componentGrouping)
            .background(
                Asset.Color.Application.Background.backgroundSecondary.swiftUIColor
            )
            .cornerRadius(CornerRadius.medium)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    FavoriteView()
}
