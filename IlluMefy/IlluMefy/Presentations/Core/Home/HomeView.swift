//
//  HomeView.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/08.
//
import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel =
    DependencyContainer.shared.resolve(HomeViewModel.self)!
    var body: some View {
        ZStack {
            RadialGradient(
                gradient: Gradient(
                    colors:
                        [Asset.Color.Button.buttonBackgroundGradationStart.swiftUIColor,
                         Asset.Color.Application.Background.background.swiftUIColor]
                ),
                center: .topLeading,
                startRadius: Layout.homeGradientStartRadius,
                endRadius: Layout.homeGradientEndRadius
            ).ignoresSafeArea()
            ScrollView {
                LazyVStack(spacing: Spacing.unrelatedComponentDivider) {
                    popularTags.sectionScrollTransition()
                    popularCreators.sectionScrollTransition()
                    recommendedCreators.sectionScrollTransition()
                    newArrivalCreators.sectionScrollTransition()
                }
            }.padding(Spacing.screenEdgePadding)
        }
        .background(Asset.Color.Application.Background.background.swiftUIColor)
        .onAppear {
            viewModel.onAppear()
        }
    }

    ///
    /// 人気クリエイター表示エリア
    ///
    private var popularCreators: some View {
        VStack {
            Text(L10n.Home.popularCreators)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title2)
                .bold()
            ScrollView(.horizontal) {
                HStack {
                    ForEach(viewModel.popularCreators) { creator in
                        CreatorTile(creator: creator)
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
            Text(L10n.Home.popularTags)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title2)
                .bold()
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.relatedComponentDivider) {
                    ForEach(viewModel.popularTags) { tag in
                        TagTile(tag: tag)
                    }
                }
                .padding(.trailing, Spacing.screenEdgePadding)
            }
        }
    }
    
    ///
    /// おすすめクリエイター表示エリア
    ///
    private var recommendedCreators: some View {
        VStack {
            Text(L10n.Home.recommendedCreators)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title2)
                .bold()
            ScrollView(.horizontal) {
                HStack {
                    ForEach(viewModel.recommendedCreators) { creator in
                        CreatorTile(creator: creator)
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
            Text(L10n.Home.recentlyAddedCreators)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title2)
                .bold()
            ScrollView(.horizontal) {
                HStack {
                    ForEach(viewModel.newArrivalCreators) { creator in
                        CreatorTile(creator: creator)
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
                .opacity(phase.isIdentity ? Effects.visibleOpacity : Effects.dimmedOpacity)
                .scaleEffect(phase.isIdentity ? Effects.visibleOpacity : Effects.scaledDown)
        }
    }
}

#Preview {
    HomeView()
}
