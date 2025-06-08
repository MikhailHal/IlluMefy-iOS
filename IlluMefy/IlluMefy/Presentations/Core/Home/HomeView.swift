//
//  HomeView.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/08.
//
import SwiftUI

struct HomeView: View {
    let mockCreator = Creator(
        id: "creator_001",
        name: "ゲーム実況者A",
        thumbnailUrl: "https://picsum.photos/200/200?random=1",
        viewCount: 5000,
        socialLinkClickCount: 1500,
        platformClickRatio: [
            .youtube: 0.7,
            .twitch: 0.3,
            .tiktok: 0.8
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
    
    var body: some View {
        ZStack {
            RadialGradient(
                gradient: Gradient(
                    colors:
                        [Asset.Color.Button.buttonBackgroundGradationStart.swiftUIColor,
                         Asset.Color.Application.Background.background.swiftUIColor]
                ),
                center: .topLeading,
                startRadius: 50,
                endRadius: 250
            ).ignoresSafeArea()
            ScrollView {
                LazyVStack(spacing: Spacing.unrelatedComponentDivider) {
                    popularTags.sectionScrollTransition()
                    popularCreators.sectionScrollTransition()
                    recommendedCreators.sectionScrollTransition()
                    newArrivalCreators.sectionScrollTransition()
                }
            }.padding(Spacing.screenEdgePadding)
        }.background(Asset.Color.Application.Background.background.swiftUIColor)
    }

    ///
    /// 人気クリエイター表示エリア
    ///
    private var popularCreators: some View {
        VStack {
            Text("人気クリエイター")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title2)
                .bold()
            ScrollView(.horizontal) {
                HStack {
                    ForEach(1..<15) { _ in
                        CreatorTile(creator: mockCreator)
                    }
                }
            }
        }
    }
    
    ///
    /// 人気タグ表示エリア
    ///
    private var popularTags: some View {
        VStack {
            Text("人気タグ")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title2)
                .bold()
            ScrollView(.horizontal) {
                HStack {
                    ForEach(1..<15) { _ in
                        CreatorTile(creator: mockCreator)
                    }
                }
            }
        }
    }
    
    ///
    /// おすすめクリエイター表示エリア
    ///
    private var recommendedCreators: some View {
        VStack {
            Text("おすすめクリエイター")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title2)
                .bold()
            ScrollView(.horizontal) {
                HStack {
                    ForEach(1..<15) { _ in
                        CreatorTile(creator: mockCreator)
                    }
                }
            }
        }
    }
    
    ///
    /// 新規クリエイター表示エリア
    ///
    private var newArrivalCreators: some View {
        VStack {
            Text("最近追加されたクリエイター")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title2)
                .bold()
            ScrollView(.horizontal) {
                HStack {
                    ForEach(1..<15) { _ in
                        CreatorTile(creator: mockCreator)
                    }
                }
            }
        }
    }
}

extension View {
    func sectionScrollTransition() -> some View {
        self.scrollTransition { content, phase in
            content
                .opacity(phase.isIdentity ? 1.0 : 0.7)
                .scaleEffect(phase.isIdentity ? 1.0 : 0.95)
                .blur(radius: phase.isIdentity ? 0 : 3)
        }
    }
}

#Preview {
    HomeView()
}
