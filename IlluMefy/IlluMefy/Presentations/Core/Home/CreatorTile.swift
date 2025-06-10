//
//  CreatorTile.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/09.
//
import SwiftUI

struct CreatorTile: View {
    let creator: Creator
    var body: some View {
        ZStack(alignment: .bottom) {
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
            Rectangle()
                .fill(Asset.Color.Application.Background.background.swiftUIColor.opacity(0.3))
                .frame(height: 40)
                .clipShape(.rect(
                    topLeadingRadius: 0,
                    bottomLeadingRadius: 16,
                    bottomTrailingRadius: 16,
                    topTrailingRadius: 0)
                )
            Text(creator.name)
                .font(.caption)
                .bold()
                .frame(maxWidth: .infinity, maxHeight: 40, alignment: .center)
        }
        .frame(width: 120, height: 180)
        .cornerRadius(16)
        .overlay(alignment: .topLeading) {
            ZStack {
                Rectangle()
                    .fill(Asset.Color.Application.Background.background.swiftUIColor.opacity(0.8))
                    .clipShape(.rect(
                        topLeadingRadius: 16,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 8,
                        topTrailingRadius: 0)
                    )
                // YouTubeだけシステムアイコン使用
                let platform = creator.mainPlatform().0
                if platform == .youtube {
                    Image(systemName: platform.icon)
                        .platformIconStyle()
                        .foregroundColor(.red)
                } else {
                    Image(platform.icon).platformIconStyle()
                }

            }.frame(width: 50, height: 35)
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
    CreatorTile(creator: mockCreator)
}
