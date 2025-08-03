import SwiftUI
import Shimmer

// MARK: - Add Tag Component
struct IlluMefyAddTag: View {
    @State private var isPressed = false
    @State private var isEditing = false
    @State private var tagText = ""
    @FocusState private var isFocused: Bool
    
    let onAdd: ((String) -> Void)?
    
    init(onAdd: ((String) -> Void)? = nil) {
        self.onAdd = onAdd
    }
    
    var body: some View {
        if isEditing {
            editingView
        } else {
            addButton
        }
    }
    
    private var addButton: some View {
        HStack(spacing: Spacing.relatedComponentDivider) {
            Image(systemName: "plus")
                .frame(maxWidth: 10)
                .foregroundColor(Asset.Color.Tag.tagBackgroundGradationStart.swiftUIColor)
            Text("タグ追加")
                .font(.system(size: Typography.bodyRegular, weight: .medium))
                .foregroundColor(Asset.Color.Tag.tagBackgroundGradationStart.swiftUIColor)
        }
        .padding(.horizontal, Spacing.medium)
        .padding(.vertical, Spacing.componentGrouping)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.tag)
                .stroke(
                    style: StrokeStyle(lineWidth: 1.5, dash: [6, 4])
                )
                .foregroundColor(Asset.Color.Tag.tagBorder.swiftUIColor.opacity(0.6))
        )
        .scaleEffect(isPressed ? Effects.scalePressed : Effects.visibleOpacity)
        .animation(.easeInOut(duration: AnimationDuration.buttonPress), value: isPressed)
        .onTapGesture {
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            
            withAnimation(.easeInOut(duration: AnimationDuration.buttonPress)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + AnimationDuration.buttonPress) {
                isPressed = false
                isEditing = true
                isFocused = true
            }
        }
    }
    
    private var editingView: some View {
        HStack(spacing: Spacing.relatedComponentDivider) {
            TextField("タグ名を入力", text: $tagText)
                .font(.system(size: Typography.bodyRegular, weight: .medium))
                .foregroundColor(Asset.Color.Tag.tagText.swiftUIColor)
                .focused($isFocused)
                .onSubmit {
                    submitTag()
                }
            
            Button(action: submitTag) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
            
            Button(action: cancelEditing) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red.opacity(0.7))
            }
        }
        .padding(.horizontal, Spacing.medium)
        .padding(.vertical, Spacing.componentGrouping)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.tag)
                .stroke(Asset.Color.Tag.tagBorder.swiftUIColor, lineWidth: 2)
        )
        .onAppear {
            isFocused = true
        }
    }
    
    private func submitTag() {
        guard !tagText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            cancelEditing()
            return
        }
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        onAdd?(tagText)
        tagText = ""
        isEditing = false
        isFocused = false
    }
    
    private func cancelEditing() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        tagText = ""
        isEditing = false
        isFocused = false
    }
}

#Preview("Add Button") {
    VStack(spacing: 16) {
        IlluMefyAddTag { tagName in
            print("Added tag: \(tagName)")
        }
    }
    .padding()
}

#Preview("Editing State") {
    struct PreviewWrapper: View {
        @State private var tags: [String] = ["既存タグ1", "既存タグ2"]
        
        var body: some View {
            VStack(spacing: 16) {
                HStack(spacing: 8) {
                    ForEach(tags, id: \.self) { tag in
                        IlluMefyFeaturedTag(text: tag)
                    }
                    
                    IlluMefyAddTag { tagName in
                        tags.append(tagName)
                    }
                }
            }
            .padding()
        }
    }
    
    return PreviewWrapper()
}
