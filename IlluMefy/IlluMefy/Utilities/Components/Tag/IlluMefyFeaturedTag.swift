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
    let onLongPress: ((IlluMefyTagDisplayable) -> Void)?
    let isDeletable: Bool
    @State private var isPressed = false
    @State private var isLongPressing = false
    
    init(
        tagData: IlluMefyTagDisplayable?,
        onTapped: ((IlluMefyTagDisplayable) -> Void)? = nil,
        onLongPress: ((IlluMefyTagDisplayable) -> Void)? = nil,
        isDeletable: Bool = false
    ) {
        self.tagData = tagData
        self.onTapped = onTapped
        self.onLongPress = onLongPress
        self.isDeletable = isDeletable
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
                .fill(isLongPressing && isDeletable ? 
                    AnyShapeStyle(Asset.Color.CreatorDetailCard.creatorDetailCardLongPressing.swiftUIColor) :
                    AnyShapeStyle(LinearGradient(
                        colors: [
                            Asset.Color.Tag.tagBackgroundGradationStart.swiftUIColor, 
                            Asset.Color.Tag.tagBackgroundGradationEnd.swiftUIColor
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                )
        )
        .scaleEffect(isPressed ? Effects.scalePressed : Effects.visibleOpacity)
        .animation(.easeInOut(duration: AnimationDuration.buttonPress), value: isPressed)
        .animation(.easeInOut(duration: 0.2), value: isLongPressing)
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
        .onLongPressGesture(minimumDuration: 0.5) {
            guard let onLongPress = onLongPress, isDeletable else { return }
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            onLongPress(tagData)
        } onPressingChanged: { isPressing in
            guard isDeletable else { return }
            withAnimation(.easeInOut(duration: 0.2)) {
                isLongPressing = isPressing
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
    init(tag: Tag?, onTapped: ((Tag) -> Void)? = nil, onLongPress: ((Tag) -> Void)? = nil, isDeletable: Bool = false) {
        self.tagData = tag
        self.onTapped = { tagData in
            guard let tag = tagData as? Tag else { return }
            onTapped?(tag)
        }
        self.onLongPress = { tagData in
            guard let tag = tagData as? Tag else { return }
            onLongPress?(tag)
        }
        self.isDeletable = isDeletable
    }
    
    // For String data
    init(text: String?, onTapped: ((String) -> Void)? = nil, onLongPress: ((String) -> Void)? = nil, isDeletable: Bool = false) {
        self.tagData = text
        self.onTapped = { tagData in
            guard let text = tagData as? String else { return }
            onTapped?(text)
        }
        self.onLongPress = { tagData in
            guard let text = tagData as? String else { return }
            onLongPress?(text)
        }
        self.isDeletable = isDeletable
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
