import SwiftUI
import Shimmer

// MARK: - Add Tag Component
struct IlluMefyAddTag: View {
    @State private var isPressed = false
    @State private var tagText = ""
    
    let onTap: (() -> Void)?
    
    init(onTap: (() -> Void)? = nil) {
        self.onTap = onTap
    }
    
    var body: some View {
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
            onTap?()
        }
    }
}

#Preview("Add Button") {
    VStack(spacing: 16) {
        IlluMefyAddTag { }
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
                    
                    IlluMefyAddTag { }
                }
            }
            .padding()
        }
    }
    
    return PreviewWrapper()
}
