//
//  SearchView.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/08.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel: SearchViewModel
    
    init() {
        let container = DependencyContainer.shared
        guard let viewModel = container.container.resolve(SearchViewModel.self) else {
            fatalError("Failed to resolve SearchViewModel")
        }
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 検索バー
            searchBarSection
            // メインコンテンツ
            mainContentSection
        }
    }
    
    // MARK: - View Components
    
    private var searchBarSection: some View {
        ZStack(alignment: .top) {
            // ベースのレイアウト
            VStack(spacing: Spacing.relatedComponentDivider) {
                // シンプルな検索ボックス
                TextField("タグを検索...", text: $viewModel.searchText)
                    .textFieldStyle(
                        NormalTextFieldStyle(
                            isEnabled: true,
                            text: $viewModel.searchText,
                            placeholder: "タグを検索...",
                            keyboardType: .default,
                            textContentType: nil
                        )
                    )
                    .onChange(of: viewModel.searchText) { _, newValue in
                        // 日本語入力中でもリアルタイムで検索候補を更新
                        // onChange内でViewModelのupdateSuggestionsを直接呼び出し
                    }
                
                // 選択されたタグ
                if !viewModel.selectedTags.isEmpty {
                    selectedTagsView(
                        tags: viewModel.selectedTags,
                        onRemove: { tag in
                            viewModel.removeTag(tag)
                        }
                    )
                }
                
                // 検索履歴
                if !viewModel.searchHistory.isEmpty && viewModel.selectedTags.isEmpty {
                    searchHistorySection
                }
            }
            .padding(Spacing.screenEdgePadding)
            
            // オートコンプリート候補をオーバーレイ表示
            if !viewModel.suggestions.isEmpty {
                GeometryReader { geometry in
                    VStack(spacing: 0) {
                        // 検索バーの高さ分のスペース
                        Spacer()
                            .frame(height: 60) // 検索バーの高さ分
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            LazyVStack(spacing: 0) {
                                ForEach(viewModel.suggestions, id: \.id) { tag in
                                    Button(action: {
                                        viewModel.addSelectedTagFromSuggestion(tag)
                                    }, label: {
                                        HStack {
                                            Text(tag.displayName)
                                                .font(.body)
                                                .foregroundColor(Asset.Color.Application.foreground.swiftUIColor)
                                            
                                            Spacer()
                                            
                                            Text("\(tag.clickedCount)回")
                                                .font(.caption)
                                                .foregroundColor(Asset.Color.TextField.placeholderNoneFocused.swiftUIColor)
                                        }
                                        .padding(.horizontal, Spacing.componentGrouping)
                                        .padding(.vertical, Spacing.relatedComponentDivider)
                                    })
                                    .buttonStyle(PlainButtonStyle())
                                    .background(Asset.Color.TextField.background.swiftUIColor)
                                    
                                    if tag.id != viewModel.suggestions.last?.id {
                                        Divider()
                                            .background(Asset.Color.TextField.borderNoneFocused.swiftUIColor)
                                    }
                                }
                            }
                        }
                        .frame(maxHeight: geometry.size.height - 80) // 検索バー分を引いた残り全体
                        .background(Asset.Color.TextField.background.swiftUIColor)
                        .cornerRadius(CornerRadius.button)
                        .overlay(
                            RoundedRectangle(cornerRadius: CornerRadius.button)
                                .stroke(Asset.Color.TextField.borderFocused.swiftUIColor, lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                        .padding(.horizontal, Spacing.screenEdgePadding)
                        
                        Spacer()
                    }
                }
                .zIndex(1000) // 最前面に表示
            }
        }
    }
    
    private var searchHistorySection: some View {
        VStack(alignment: .leading, spacing: Spacing.relatedComponentDivider) {
            Text(L10n.Search.recentSearches)
                .font(.caption)
                .foregroundColor(Asset.Color.TextField.placeholderNoneFocused.swiftUIColor)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.componentGrouping) {
                    ForEach(viewModel.searchHistory, id: \.self) { query in
                        Button(action: {
                            viewModel.addTagsFromHistory(query)
                        }, label: {
                            Text(query)
                                .font(.caption)
                                .padding(.horizontal, Spacing.componentGrouping)
                                .padding(.vertical, Spacing.relatedComponentDivider)
                                .background(Asset.Color.TextField.background.swiftUIColor)
                                .foregroundColor(Asset.Color.Application.foreground.swiftUIColor)
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
                .foregroundColor(Asset.Color.TextField.placeholderNoneFocused.swiftUIColor)
            Text("タグを選択してクリエイターを探してみましょう")
                .font(.headline)
                .foregroundColor(Asset.Color.TextField.placeholderNoneFocused.swiftUIColor)
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
                .foregroundColor(Asset.Color.TextField.placeholderNoneFocused.swiftUIColor)
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
                            .foregroundColor(Asset.Color.Application.foreground.swiftUIColor)
                        
                        Button(action: {
                            onRemove(tag)
                        }, label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.caption)
                                .foregroundColor(
                                    Asset.Color.TextField.placeholderNoneFocused.swiftUIColor
                                )
                        })
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal, Spacing.componentGrouping)
                    .padding(.vertical, Spacing.relatedComponentDivider)
                    .background(Asset.Color.Button.buttonBackgroundGradationStart.swiftUIColor)
                    .cornerRadius(CornerRadius.tag)
                }
            }
            .padding(.horizontal, Spacing.screenEdgePadding)
        }
        .frame(maxHeight: 40)
    }
    
    private func creatorResultsView(creators: [Creator]) -> some View {
        ScrollView {
            LazyVStack(spacing: Spacing.relatedComponentDivider) {
                ForEach(creators) { creator in
                    creatorListItem(creator: creator)
                }
                
                // Load More Indicator
                if viewModel.hasMore {
                    HStack {
                        ProgressView()
                            .scaleEffect(0.8)
                        Text(L10n.Common.loading)
                            .font(.caption)
                            .foregroundColor(Asset.Color.TextField.placeholderNoneFocused.swiftUIColor)
                    }
                    .frame(maxWidth: .infinity)
                    .onAppear {
                        Task {
                            await viewModel.loadMore()
                        }
                    }
                }
            }
            .padding(Spacing.screenEdgePadding)
        }
        .refreshable {
            await viewModel.search()
        }
    }
    
    private func creatorListItem(creator: Creator) -> some View {
        CreatorListItemView(creator: creator)
    }
    
}

struct CreatorListItemView: View {
    let creator: Creator
    @State private var showingDetail = false
    
    var body: some View {
        HStack(spacing: Spacing.componentGrouping) {
            // クリエイター画像
            AsyncImage(url: URL(string: creator.thumbnailUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Asset.Color.TextField.background.swiftUIColor)
                    .overlay(
                        ProgressView()
                            .scaleEffect(0.8)
                    )
            }
            .frame(width: 80, height: 80)
            .cornerRadius(CornerRadius.button)
            
            // クリエイター情報
            VStack(alignment: .leading, spacing: Spacing.relatedComponentDivider) {
                // 名前
                Text(creator.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Asset.Color.Application.foreground.swiftUIColor)
                    .lineLimit(1)
                
                // 説明
                if (creator.description != nil) && (!creator.description!.isEmpty) {
                    Text(creator.description!)
                        .font(.subheadline)
                        .foregroundColor(Asset.Color.TextField.placeholderNoneFocused.swiftUIColor)
                        .lineLimit(2)
                }
                
                // タグとメトリクス
                HStack {
                    // タグ
                    if !creator.relatedTag.isEmpty {
                        HStack(spacing: Spacing.relatedComponentDivider) {
                            ForEach(Array(creator.relatedTag.prefix(2)), id: \.self) { tagId in
                                // タグIDを表示名に変換（簡略化のため、ここではそのまま表示）
                                Text(tagId)
                                    .font(.caption)
                                    .foregroundColor(Asset.Color.Button.buttonBackgroundGradationStart.swiftUIColor)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(
                                        Capsule()
                                            .fill(Asset.Color.Button.buttonBackgroundGradationStart.swiftUIColor.opacity(0.1))
                                    )
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // 視聴回数
                    Text("\(formatViewCount(creator.viewCount)) views")
                        .font(.caption)
                        .foregroundColor(Asset.Color.TextField.placeholderNoneFocused.swiftUIColor)
                }
            }
            
            Spacer()
            
            // プラットフォームアイコン
            VStack {
                let platform = creator.mainPlatform().0
                Group {
                    if platform == .youtube {
                        Image(systemName: platform.icon)
                            .foregroundColor(.red)
                    } else {
                        Image(platform.icon)
                            .resizable()
                            .foregroundColor(Asset.Color.Application.foreground.swiftUIColor)
                    }
                }
                .frame(width: 24, height: 24)
                .font(.title2)
                
                if creator.platform.count > 1 {
                    Text("+\(creator.platform.count - 1)")
                        .font(.caption2)
                        .foregroundColor(Asset.Color.TextField.placeholderNoneFocused.swiftUIColor)
                }
            }
        }
        .padding(Spacing.componentGrouping)
        .background(Asset.Color.TextField.background.swiftUIColor)
        .cornerRadius(CornerRadius.button)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.button)
                .stroke(Asset.Color.TextField.borderNoneFocused.swiftUIColor, lineWidth: 1)
        )
        .onTapGesture {
            showingDetail = true
        }
        .sheet(isPresented: $showingDetail) {
            NavigationStack {
                CreatorDetailView(creatorId: creator.id)
            }
        }
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
                .foregroundColor(Asset.Color.TextField.placeholderNoneFocused.swiftUIColor)
            Text(L10n.Search.noResults)
                .font(.headline)
                .foregroundColor(Asset.Color.TextField.placeholderNoneFocused.swiftUIColor)
            Text(L10n.Search.noResultsMessage)
                .font(.subheadline)
                .foregroundColor(Asset.Color.TextField.placeholderNoneFocused.swiftUIColor)
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
                .foregroundColor(Asset.Color.TextField.placeholderNoneFocused.swiftUIColor)
                .multilineTextAlignment(.center)
            Button(L10n.Common.retry) {
                Task {
                    await viewModel.search()
                }
            }
            .buttonStyle(.borderedProminent)
            Spacer()
        }
        .padding(Spacing.screenEdgePadding)
    }
}

#Preview {
    SearchView()
}
