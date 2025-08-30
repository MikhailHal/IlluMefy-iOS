//
//  SearchView.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/08.
//

import SwiftUI
import UIKit

struct SearchView: View {
    @State private var viewModel: SearchViewModel =
    DependencyContainer.shared.resolve(SearchViewModel.self)!
    
    var body: some View {
        ZStack {
            Asset.Color.Application.Background.backgroundPrimary.swiftUIColor
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                searchBarSection
                mainContentSection
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    // MARK: - View Components
    
    private var searchBarSection: some View {
        SearchBar(
            text: $viewModel.searchText,
            isEditing: $viewModel.isEditing,
            searchBarStyle: SearchBarStyle()
        )
        .padding(.horizontal, Spacing.screenEdgePadding)
        .padding(.top, Spacing.screenEdgePadding)
    }
    
    private var searchHistorySection: some View {
        VStack(alignment: .leading, spacing: Spacing.relatedComponentDivider) {
            HStack {
                Text(L10n.Search.recentSearches)
                    .font(.caption)
                    .foregroundColor(Asset.Color.SearchResult.searchResultSubtitle.swiftUIColor)
                
                Spacer()
                
                if !viewModel.searchHistory.isEmpty {
                    Button(L10n.Search.clearHistory) {
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()
                        Task {
                            await viewModel.clearHistory()
                        }
                    }
                    .font(.caption)
                    .foregroundColor(Asset.Color.Application.accent.swiftUIColor)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.componentGrouping) {
                    ForEach(viewModel.searchHistory, id: \.self) { query in
                        Button(action: {
                            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                            impactFeedback.impactOccurred()
                            //viewModel.addTagsFromHistory(query)
                        }, label: {
                            Text(query)
                                .font(.caption)
                                .padding(.horizontal, Spacing.componentGrouping)
                                .padding(.vertical, Spacing.relatedComponentDivider)
                                .background(Asset.Color.SearchTag.searchTagBackground.swiftUIColor)
                                .foregroundColor(Asset.Color.SearchTag.searchTagText.swiftUIColor)
                                .cornerRadius(CornerRadius.tag)
                        })
                    }
                }
                .padding(.horizontal, Spacing.screenEdgePadding)
            }
        }
    }
    
    private var mainContentSection: some View {
        Group {
            switch viewModel.state {
            case .initial:
                initialStateView
            case .searching:
                loadingView
            case .loadedCreators(let creators):
                creatorResultsView(creators: creators)
            case .empty:
                emptyStateView
            case .error(let title, let message):
                errorView(title: title, message: message)
            }
        }
    }
    
    private var initialStateView: some View {
        VStack(spacing: Spacing.unrelatedComponentDivider) {
            Spacer()
            Image(systemName: "magnifyingglass")
                .font(.system(size: Typography.titleExtraLarge))
                .foregroundColor(Asset.Color.SearchEmpty.searchEmptyIcon.swiftUIColor)
            Text(L10n.Search.searchPrompt)
                .font(.headline)
                .foregroundColor(Asset.Color.SearchEmpty.searchEmptyTitle.swiftUIColor)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding(Spacing.screenEdgePadding)
    }
    
    private var loadingView: some View {
        VStack(spacing: Spacing.unrelatedComponentDivider) {
            Spacer()
            ProgressView()
                .scaleEffect(Effects.scaleIcon)
            Text(L10n.Common.loading)
                .font(.headline)
                .foregroundColor(Asset.Color.SearchEmpty.searchEmptyTitle.swiftUIColor)
            Spacer()
        }
        .padding(Spacing.screenEdgePadding)
    }
    
    // MARK: - Helper Views
    
    private func selectedTagsView(
        tags: [Tag],
        onRemove: @escaping (Tag) -> Void
    ) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.componentGrouping) {
                ForEach(tags, id: \.id) { tag in
                    HStack(spacing: Spacing.componentGrouping / 2) {
                        Text(tag.displayName)
                            .font(.caption)
                            .foregroundColor(Asset.Color.SearchTag.searchTagText.swiftUIColor)
                        
                        Button(action: {
                            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                            impactFeedback.impactOccurred()
                            onRemove(tag)
                        }, label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.caption)
                                .foregroundColor(Asset.Color.SearchTag.searchTagRemove.swiftUIColor)
                        })
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal, Spacing.componentGrouping)
                    .padding(.vertical, Spacing.relatedComponentDivider)
                    .background(Asset.Color.SearchTag.searchTagBackgroundSelected.swiftUIColor)
                    .cornerRadius(CornerRadius.tag)
                }
            }
            .padding(.horizontal, Spacing.screenEdgePadding)
        }
        .frame(maxHeight: 40)
    }
    
    private func creatorResultsView(creators: [Creator]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // 検索結果の件数表示
            HStack {
                if viewModel.totalCount > creators.count {
                    Text(L10n.Search.resultsCountWithTotal(viewModel.totalCount, creators.count))
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(Asset.Color.SearchResult.searchResultTitle.swiftUIColor)
                } else {
                    Text(L10n.Search.resultsCount(creators.count))
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(Asset.Color.SearchResult.searchResultTitle.swiftUIColor)
                }
                
                Spacer()
                
                if viewModel.hasMore {
                    Text(L10n.Search.loadMore)
                        .font(.caption)
                        .foregroundColor(Asset.Color.Application.accent.swiftUIColor)
                }
            }
            .padding(.horizontal, Spacing.screenEdgePadding)
            .padding(.vertical, Spacing.componentGrouping)
            
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 0),
                    GridItem(.flexible(), spacing: 0),
                    GridItem(.flexible(), spacing: 0)
                ], spacing: 0) {
                    ForEach(creators) { creator in
                        SearchCreatorCard(creator: creator, viewModel: viewModel)
                    }
                    
                    // Load More Indicator
                    if viewModel.hasMore {
                        VStack {
                            ProgressView()
                                .scaleEffect(0.8)
                            Text(L10n.Common.loading)
                                .font(.caption)
                                .foregroundColor(Asset.Color.SearchResult.searchResultMetrics.swiftUIColor)
                        }
                        .frame(maxWidth: .infinity)
                        .gridCellColumns(3) // 3列すべてを占有
                        .onAppear {
                            Task {
                                await viewModel.loadMore()
                            }
                        }
                    }
                }
                .padding(0)
            }
            .refreshable {
                await viewModel.search()
            }
        }
    }
    
}

struct SearchCreatorCard: View {
    let creator: Creator
    let viewModel: SearchViewModel
    @EnvironmentObject private var router: IlluMefyAppRouter
    
    var body: some View {
        GeometryReader { geometry in
            Button(action: {
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
                router.navigate(to: .creatorDetail(creator: creator))
            }, label: {
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
                    VStack(alignment: .leading, spacing: 2) {
                        Text(creator.name)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .shadow(radius: 1)
                    }
                    .padding(8)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                }
            })
            .buttonStyle(PlainButtonStyle())
        }
        .aspectRatio(9/16, contentMode: .fit) // TikTok風の縦長アスペクト比
    }
    
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

extension SearchView {
    private var emptyStateView: some View {
        VStack(spacing: Spacing.unrelatedComponentDivider) {
            Spacer()
            Image(systemName: "magnifyingglass")
                .font(.system(size: Typography.titleExtraLarge))
                .foregroundColor(Asset.Color.SearchEmpty.searchEmptyIcon.swiftUIColor)
            Text(L10n.Search.noResults)
                .font(.headline)
                .foregroundColor(Asset.Color.SearchEmpty.searchEmptyTitle.swiftUIColor)
            Text(L10n.Search.noResultsMessage)
                .font(.subheadline)
                .foregroundColor(Asset.Color.SearchEmpty.searchEmptyMessage.swiftUIColor)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding(Spacing.screenEdgePadding)
    }
    
    private func errorView(title: String, message: String) -> some View {
        VStack(spacing: Spacing.unrelatedComponentDivider) {
            Spacer()
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: Typography.titleExtraLarge))
                .foregroundColor(Asset.Color.WarningText.warningLabelForground.swiftUIColor)
            Text(title)
                .font(.headline)
                .bold()
            Text(message)
                .font(.subheadline)
                .foregroundColor(Asset.Color.SearchEmpty.searchEmptyMessage.swiftUIColor)
                .multilineTextAlignment(.center)
            Button(L10n.Common.retry) {
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
                Task {
                    await viewModel.search()
                }
            }
            .buttonStyle(.borderedProminent)
            Spacer()
        }
        .padding(Spacing.screenEdgePadding)
    }
    
    // MARK: - Helper Methods
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    SearchView()
}
