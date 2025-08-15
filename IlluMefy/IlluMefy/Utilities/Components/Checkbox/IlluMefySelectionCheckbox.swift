//
//  IlluMefySelectionCheckbox.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/14.
//

import SwiftUI

/// 複数選択可能なチェックボックスコンポーネント
struct IlluMefySelectionCheckbox<T: Hashable>: View {
    
    // MARK: - Properties
    
    let title: String
    let items: [SelectionItem<T>]
    @Binding var selectedItems: Set<T>
    let columns: Int
    
    struct SelectionItem<Value: Hashable> {
        let value: Value
        let label: String
        let icon: String?
        
        init(value: Value, label: String, icon: String? = nil) {
            self.value = value
            self.label = label
            self.icon = icon
        }
    }
    
    // MARK: - Initializer
    
    init(
        title: String,
        items: [SelectionItem<T>],
        selectedItems: Binding<Set<T>>,
        columns: Int = 1
    ) {
        self.title = title
        self.items = items
        self._selectedItems = selectedItems
        self.columns = columns
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.relatedComponentDivider) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            if columns == 1 {
                singleColumnLayout
            } else {
                multiColumnLayout
            }
        }
    }
    
    // MARK: - Private Views
    
    private var singleColumnLayout: some View {
        VStack(alignment: .leading, spacing: Spacing.componentGrouping) {
            ForEach(items, id: \.value) { item in
                checkboxRow(for: item)
            }
        }
    }
    
    private var multiColumnLayout: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible()), count: columns),
            alignment: .leading,
            spacing: Spacing.componentGrouping
        ) {
            ForEach(items, id: \.value) { item in
                checkboxRow(for: item)
            }
        }
    }
    
    private func checkboxRow(for item: SelectionItem<T>) -> some View {
        Button(action: {
            toggleSelection(for: item.value)
        }, label: {
            HStack(spacing: Spacing.relatedComponentDivider) {
                // Checkbox
                RoundedRectangle(cornerRadius: CornerRadius.checkbox)
                    .fill(
                        selectedItems.contains(item.value) ?
                            Asset.Color.Checkbox.checkboxBackgroundFilled.swiftUIColor :
                            Asset.Color.Checkbox.checkboxBackgroundNotFilled.swiftUIColor
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: CornerRadius.checkbox)
                            .strokeBorder(
                                selectedItems.contains(item.value) ?
                                    Asset.Color.Checkbox.checkboxBackgroundFilled.swiftUIColor :
                                    Asset.Color.TextField.borderNoneFocused.swiftUIColor,
                                lineWidth: BorderWidth.checkbox
                            )
                    )
                    .overlay(
                        Image(systemName: "checkmark")
                            .font(.system(size: Typography.captionSmall, weight: .bold))
                            .foregroundColor(Asset.Color.Checkbox.checkboxForegroundFilled.swiftUIColor)
                            .opacity(selectedItems.contains(item.value) ? Opacity.primaryText : 0)
                    )
                    .frame(width: Size.checkboxSize, height: Size.checkboxSize)
                
                // Icon (if provided)
                if let icon = item.icon {
                    Image(systemName: icon)
                        .font(.system(size: Typography.bodyRegular))
                        .foregroundColor(.primary)
                }
                
                // Label
                Text(item.label)
                    .font(.system(size: Typography.bodyRegular))
                    .foregroundColor(.primary)
                
                Spacer()
            }
        })
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Private Methods
    
    private func toggleSelection(for value: T) {
        withAnimation(.easeInOut(duration: AnimationDuration.instant)) {
            if selectedItems.contains(value) {
                selectedItems.remove(value)
            } else {
                selectedItems.insert(value)
            }
        }
    }
}

// MARK: - Preview

#Preview("Single Column") {
    struct PreviewWrapper: View {
        @State private var selectedItems: Set<String> = ["item1"]
        
        var body: some View {
            VStack {
                IlluMefySelectionCheckbox(
                    title: "修正したい項目",
                    items: [
                        .init(value: "item1", label: "クリエイター名", icon: "person.fill"),
                        .init(value: "item2", label: "プロフィール画像", icon: "camera.fill"),
                        .init(value: "item3", label: "SNSリンク", icon: "link"),
                        .init(value: "item4", label: "タグ", icon: "tag.fill")
                    ],
                    selectedItems: $selectedItems
                )
                .padding()
                
                Text("選択中: \(selectedItems.sorted().joined(separator: ", "))")
                    .padding()
            }
        }
    }
    
    return PreviewWrapper()
}

#Preview("Multi Column") {
    struct PreviewWrapper: View {
        @State private var selectedPlatforms: Set<PlatformDomainModel> = [.youtube]
        
        var body: some View {
            IlluMefySelectionCheckbox(
                title: "プラットフォーム",
                items: PlatformDomainModel.allCases.map { platform in
                    .init(value: platform, label: platform.displayName)
                },
                selectedItems: $selectedPlatforms,
                columns: 2
            )
            .padding()
        }
    }
    
    return PreviewWrapper()
}