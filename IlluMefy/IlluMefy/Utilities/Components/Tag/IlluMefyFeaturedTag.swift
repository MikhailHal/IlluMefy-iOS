import SwiftUI
import Shimmer

// MARK: - Generic Protocol for Tag Data
protocol IlluMefyTagDisplayable {
    var displayText: String { get }
}

// MARK: - Reusable Featured Tag Component
struct IlluMefyFeaturedTag: View {
    let tagData: IlluMefyTagDisplayable?
    let onTapped: ((IlluMefyTagDisplayable) -> Void)?
    @State private var isPressed = false
    
    init(
        tagData: IlluMefyTagDisplayable?,
        onTapped: ((IlluMefyTagDisplayable) -> Void)? = nil
    ) {
        self.tagData = tagData
        self.onTapped = onTapped
    }
    
    var body: some View {
        if let tagData = tagData {
            normalTag(tagData: tagData)
        } else {
            skeletonTag
        }
    }
    
    private func normalTag(tagData: IlluMefyTagDisplayable) -> some View {
        HStack(spacing: Spacing.relatedComponentDivider) {
            Image(systemName: "tag")
                .frame(maxWidth: 10)
            Text(tagData.displayText)
                .font(.system(size: Typography.bodyRegular, weight: .medium))
                .foregroundColor(Asset.Color.Tag.tagText.swiftUIColor)
        }
        .padding(.horizontal, Spacing.medium)
        .padding(.vertical, Spacing.componentGrouping)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.tag)
                .stroke(Asset.Color.Tag.tagBorder.swiftUIColor, lineWidth: 1)
        )
        .background(
            RoundedRectangle(cornerRadius: CornerRadius.tag)
                .fill(LinearGradient(
                    colors: [
                        Asset.Color.Tag.tagBackgroundGradationStart.swiftUIColor, 
                        Asset.Color.Tag.tagBackgroundGradationEnd.swiftUIColor
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                ))
        )
        .scaleEffect(isPressed ? Effects.scalePressed : Effects.visibleOpacity)
        .animation(.easeInOut(duration: AnimationDuration.buttonPress), value: isPressed)
        .onTapGesture {
            guard let onTapped = onTapped else { return }
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            
            withAnimation(.easeInOut(duration: AnimationDuration.buttonPress)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + AnimationDuration.buttonPress) {
                isPressed = false
                onTapped(tagData)
            }
        }
    }
    
    private var skeletonTag: some View {
        HStack(spacing: Spacing.relatedComponentDivider) {
            Image(systemName: "tag")
                .frame(maxWidth: 10)
                .foregroundColor(.gray.opacity(Opacity.glow))
            Rectangle()
                .fill(.gray.opacity(Opacity.glow))
                .frame(width: 80, height: 16)
                .cornerRadius(4)
        }
        .padding(.horizontal, Spacing.medium)
        .padding(.vertical, Spacing.componentGrouping)
        .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.tag)
                .stroke(.gray.opacity(Opacity.glow), lineWidth: 1)
        )
        .background(
            RoundedRectangle(cornerRadius: CornerRadius.tag)
                .fill(.gray.opacity(Opacity.overlayLight))
        )
        .shimmering()
    }
}

// MARK: - Domain Entity Extensions
extension Tag: IlluMefyTagDisplayable {
    var displayText: String { displayName }
}

// MARK: - String Extension for Simple Use Cases
extension String: IlluMefyTagDisplayable {
    var displayText: String { self }
}

// MARK: - Convenience Initializers
extension IlluMefyFeaturedTag {
    // For Tag entities
    init(tag: Tag?, onTapped: ((Tag) -> Void)? = nil) {
        self.tagData = tag
        self.onTapped = { tagData in
            guard let tag = tagData as? Tag else { return }
            onTapped?(tag)
        }
    }
    
    // For String data
    init(text: String?, onTapped: ((String) -> Void)? = nil) {
        self.tagData = text
        self.onTapped = { tagData in
            guard let text = tagData as? String else { return }
            onTapped?(text)
        }
    }
}

#Preview("Normal Tag") {
    VStack(spacing: 16) {
        IlluMefyFeaturedTag(text: "スポーツ") { tagText in
            print("Tapped: \(tagText)")
        }
        IlluMefyFeaturedTag(text: "エンターテイメント")
    }
    .padding()
}

#Preview("Skeleton") {
    VStack(spacing: 16) {
        IlluMefyFeaturedTag(tagData: nil)
        IlluMefyFeaturedTag(tagData: nil)
    }
    .padding()
}
