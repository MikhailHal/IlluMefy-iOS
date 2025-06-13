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
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        ProgressView()
                    )
            }
            
            // Bottom info section
            bottomInfoSection
        }
        .frame(width: 120, height: 180)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(LinearGradient(
                    colors: [.white.opacity(0.3), .clear],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
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
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        } perform: {
            // 長押しアクション
        }
        .fullScreenCover(isPresented: $showingDetail) {
            CreatorDetailView(creatorId: creator.id)
        }
    }
    
    // MARK: - View Components
    
    private var bottomInfoSection: some View {
        VStack(spacing: 4) {
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
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .frame(maxWidth: .infinity)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .clipShape(.rect(
                    topLeadingRadius: 0,
                    bottomLeadingRadius: 16,
                    bottomTrailingRadius: 16,
                    topTrailingRadius: 0)
                )
        )
    }
    
    private var contentTagsView: some View {
        HStack(spacing: 4) {
            ForEach(Array(creator.relatedTag.prefix(2)), id: \.self) { tag in
                Text("#\(tag)")
                    .font(.system(size: 9))
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .background(
                        Capsule()
                            .fill(.white.opacity(0.2))
                    )
            }
            if creator.relatedTag.count > 2 {
                Text("...")
                    .font(.system(size: 9))
                    .foregroundColor(.white.opacity(0.6))
            }
        }
    }
    
    private var platformIconOverlay: some View {
        ZStack {
            Rectangle()
                .fill(Asset.Color.Application.Background.background.swiftUIColor.opacity(0.8))
                .clipShape(.rect(
                    topLeadingRadius: 16,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 8,
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
        .frame(width: 50, height: 35)
    }
    
    private var viewCountOverlay: some View {
        VStack {
            Text(formatViewCount(creator.viewCount))
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(
                    Capsule()
                        .fill(.black.opacity(0.6))
                )
                .padding(.top, 8)
                .padding(.trailing, 8)
            Spacer()
        }
    }
    
    private var multiplePlatformIndicator: some View {
        let platformCount = creator.platform.count
        if platformCount > 1 {
            return AnyView(
                VStack {
                    Spacer()
                    Text("+\(platformCount - 1)")
                        .font(.system(size: 9, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(.orange.opacity(0.8))
                        )
                        .padding(.bottom, 45)
                        .padding(.trailing, 6)
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
            .frame(width: 25, height: 25)
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
    .background(Color.gray.opacity(0.1))
}
