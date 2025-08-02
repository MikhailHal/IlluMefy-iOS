//
//  CreatorTile.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/09.
//
import SwiftUI
import UIKit
import Shimmer

struct CreatorTile: View {
    let creator: Creator?
    @State private var isPressed = false
    @EnvironmentObject private var router: IlluMefyAppRouter
    
    /// クリエイター情報がある場合は実際のデータを表示
    /// 無い場合はスケルトンデータを表示
    var body: some View {
        if creator != nil {
            normalCard
        } else {
            skeletonCard
        }
    }
    
    // MARK: 通常ver
    private var normalCard: some View {
        ZStack(alignment: .bottom) {
            // サムネイル画像
            AsyncImage(url: URL(string: creator!.thumbnailUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(Opacity.glow))
                    .shimmering()
            }
            bottomInfoSection
        }
        .frame(width: Size.creatorTileWidth, height: Size.creatorTileHeight)
        .cornerRadius(CornerRadius.tile)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.tile)
                .stroke(LinearGradient(
                    colors: [.white.opacity(Opacity.backgroundOverlay), .clear],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ), lineWidth: BorderWidth.medium)
        )
        .shadow(color: .black.opacity(Opacity.shadow), radius: Shadow.radiusSmall, x: 0, y: Shadow.offsetYSmall)
        .scaleEffect(isPressed ? Effects.initialScale : 1.0)
        .animation(.easeInOut(duration: AnimationDuration.instant), value: isPressed)
        .onTapGesture {
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            router.navigate(to: .creatorDetail(creatorId: creator!.id))
        }
    }
    
    // MARK: スケルトンver
    private var skeletonCard: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: URL(string: "")) { _ in
                Rectangle().fill(Color.gray.opacity(Opacity.glow))
            }
        }
        .frame(width: Size.creatorTileWidth, height: Size.creatorTileHeight)
        .cornerRadius(CornerRadius.tile)
        .shadow(color: .black.opacity(Opacity.shadow), radius: Shadow.radiusSmall, x: 0, y: Shadow.offsetYSmall)
        .shimmering()
    }
    
    // MARK: - View Components
    
    private var bottomInfoSection: some View {
        VStack(spacing: Spacing.small) {
            // Creator name
            Text(creator!.name)
                .font(.callout)
                .bold()
                .lineLimit(1)
                .foregroundColor(.white)
        }
        .padding(.horizontal, Spacing.componentGrouping)
        .padding(.vertical, Spacing.smallMedium)
        .frame(maxWidth: .infinity, maxHeight: 45)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .clipShape(.rect(
                    topLeadingRadius: 0,
                    bottomLeadingRadius: CornerRadius.tile,
                    bottomTrailingRadius: CornerRadius.tile,
                    topTrailingRadius: 0)
                )
        )
    }
}

extension Image {
    func platformIconStyle() -> some View {
        self
            .resizable()
            .frame(width: Size.platformIconSize, height: Size.platformIconSize)
    }
}

#Preview {
    let mockCreator = Creator(
        id: "creator_001",
        name: "ゲーム実況者A",
        thumbnailUrl: "https://picsum.photos/200/200?random=1",
        viewCount: 5000,
        socialLinkClickCount: 1500,
        platformClickRatio: [
            .youtube: 0.3,
            .twitch: 0.2,
            .tiktok: 0.5
        ],
        relatedTag: ["fps", "apex-legends", "valorant"],
        description: "FPSゲームをメインに実況しています。毎日20時から配信！",
        platform: [
            .youtube: "https://youtube.com/@gameplayerA",
            .twitch: "https://twitch.tv/gameplayerA",
            .tiktok: "https://tiktok.com/gameplayerA"
        ],
        createdAt: Date().addingTimeInterval(-86400 * 30),
        updatedAt: Date().addingTimeInterval(-3600),
        isActive: true
    )
    
    HStack {
        CreatorTile(creator: mockCreator)
        CreatorTile(creator: nil)
    }
    .padding()
    .background(Color.gray.opacity(Opacity.overlayLight))
}
