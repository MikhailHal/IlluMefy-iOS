//
//  CreatorTile.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/09.
//
import SwiftUI

struct CreatorTile: View {
    let creator: Creator
    @State private var isPressed = false
    @State private var showingDetail = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background image
            AsyncImage(url: URL(string: creator.thumbnailUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(Opacity.glow))
                    .overlay(
                        ProgressView()
                    )
            }
            
            // Bottom info section
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
        .overlay(alignment: .topLeading) {
            platformIconOverlay
        }
        .overlay(alignment: .topTrailing) {
            viewCountOverlay
        }
        .overlay(alignment: .bottomTrailing) {
            multiplePlatformIndicator
        }
        .onTapGesture {
            showingDetail = true
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity) { pressing in
            withAnimation(.easeInOut(duration: AnimationDuration.instant)) {
                isPressed = pressing
            }
        } perform: {
            // 長押しアクション
        }
        .sheet(isPresented: $showingDetail) {
            NavigationStack {
                CreatorDetailView(creatorId: creator.id)
            }
        }
    }
    
    // MARK: - View Components
    
    private var bottomInfoSection: some View {
        VStack(spacing: Spacing.small) {
            // Creator name
            Text(creator.name)
                .font(.caption)
                .bold()
                .lineLimit(1)
                .foregroundColor(.white)
            
            // Content tags
            if !creator.relatedTag.isEmpty {
                contentTagsView
            }
        }
        .padding(.horizontal, Spacing.componentGrouping)
        .padding(.vertical, Spacing.smallMedium)
        .frame(maxWidth: .infinity)
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
    
    private var contentTagsView: some View {
        HStack(spacing: Spacing.small) {
            ForEach(Array(creator.relatedTag.prefix(2)), id: \.self) { tag in
                Text("#\(tag)")
                    .font(.system(size: Typography.captionMini))
                    .foregroundColor(.white.opacity(Opacity.secondaryText))
                    .padding(.horizontal, Spacing.small)
                    .padding(.vertical, Spacing.extraSmall)
                    .background(
                        Capsule()
                            .fill(.white.opacity(Opacity.shadow))
                    )
            }
            if creator.relatedTag.count > 2 {
                Text(L10n.Common.more)
                    .font(.system(size: Typography.captionMini))
                    .foregroundColor(.white.opacity(Opacity.placeholder))
            }
        }
    }
    
    private var platformIconOverlay: some View {
        ZStack {
            Rectangle()
                .fill(Asset.Color.Application.Background.background.swiftUIColor.opacity(Opacity.secondaryText))
                .clipShape(.rect(
                    topLeadingRadius: CornerRadius.tile,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: CornerRadius.medium,
                    topTrailingRadius: 0)
                )
            
            // Main platform icon
            let platform = creator.mainPlatform().0
            if platform == .youtube {
                Image(systemName: platform.icon)
                    .platformIconStyle()
                    .foregroundColor(.red)
            } else {
                Image(platform.icon).platformIconStyle()
            }
        }
        .frame(width: Size.platformOverlayWidth, height: Size.platformOverlayHeight)
    }
    
    private var viewCountOverlay: some View {
        VStack {
            Text(formatViewCount(creator.viewCount))
                .font(.system(size: Typography.captionExtraSmall, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, Spacing.smallMedium)
                .padding(.vertical, Spacing.extraSmall)
                .background(
                    Capsule()
                        .fill(.black.opacity(Opacity.placeholder))
                )
                .padding(.top, Spacing.componentGrouping)
                .padding(.trailing, Spacing.componentGrouping)
            Spacer()
        }
    }
    
    private var multiplePlatformIndicator: some View {
        let platformCount = creator.platform.count
        if platformCount > 1 {
            return AnyView(
                VStack {
                    Spacer()
                    Text(L10n.Common.platformCount(platformCount - 1))
                        .font(.system(size: Typography.captionMini, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, Spacing.small)
                        .padding(.vertical, Spacing.extraSmall)
                        .background(
                            Capsule()
                                .fill(.orange.opacity(Opacity.secondaryText))
                        )
                        .padding(.bottom, Layout.platformIndicatorBottomOffset)
                        .padding(.trailing, Spacing.smallMedium)
                }
            )
        } else {
            return AnyView(EmptyView())
        }
    }
    
    // MARK: - Helper Functions
    
    private func formatViewCount(_ count: Int) -> String {
        if count >= 1000000 {
            return String(format: "%.1fM", Double(count) / 1000000)
        } else if count >= 1000 {
            return String(format: "%.1fK", Double(count) / 1000)
        } else {
            return "\(count)"
        }
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
        CreatorTile(creator: Creator(
            id: "creator_002",
            name: "VTuber B",
            thumbnailUrl: "https://picsum.photos/200/200?random=2",
            viewCount: 12000,
            socialLinkClickCount: 2000,
            platformClickRatio: [
                .niconico: 0.8,
                .youtube: 0.2
            ],
            relatedTag: ["vtuber", "singing"],
            description: "歌って踊って楽しく配信！",
            platform: [
                .niconico: "https://www.nicovideo.jp/user/123",
                .youtube: "https://youtube.com/@vtuberB"
            ],
            createdAt: Date(),
            updatedAt: Date(),
            isActive: true
        ))
    }
    .padding()
    .background(Color.gray.opacity(Opacity.overlayLight))
}
