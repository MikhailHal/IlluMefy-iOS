import SwiftUI

// 提案するカラーパレット
struct ColorPalette {
    // プライマリー
    static let primary = Color(hex: "4CAF50")
    static let primaryLight = Color(hex: "81C784")
    static let primaryDark = Color(hex: "388E3C")
    
    // セカンダリー
    static let secondary = Color(hex: "2196F3")
    static let secondaryLight = Color(hex: "64B5F6")
    static let secondaryDark = Color(hex: "1976D2")
    
    // アクセント
    static let accent = Color(hex: "FF9800")
    static let accentLight = Color(hex: "FFB74D")
    static let accentDark = Color(hex: "F57C00")
    
    // セマンティック
    static let success = Color(hex: "4CAF50")
    static let error = Color(hex: "F44336")
    static let warning = Color(hex: "FFC107")
    
    // テキスト
    static let textPrimary = Color(hex: "212121")
    static let textSecondary = Color(hex: "757575")
    static let textDisabled = Color(hex: "BDBDBD")
    
    // 背景
    static let backgroundPrimary = Color(hex: "FFFFFF")
    static let backgroundSecondary = Color(hex: "F5F5F5")
    static let backgroundTertiary = Color(hex: "EEEEEE")
}

struct ColorSystemPreview: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // プライマリーカラーパレット
                ColorPaletteSection(
                    title: "Primary Colors",
                    colors: [
                        ("Main", ColorPalette.primary),
                        ("Light", ColorPalette.primaryLight),
                        ("Dark", ColorPalette.primaryDark)
                    ]
                )
                
                // セカンダリーカラーパレット
                ColorPaletteSection(
                    title: "Secondary Colors",
                    colors: [
                        ("Main", ColorPalette.secondary),
                        ("Light", ColorPalette.secondaryLight),
                        ("Dark", ColorPalette.secondaryDark)
                    ]
                )
                
                // アクセントカラーパレット
                ColorPaletteSection(
                    title: "Accent Colors",
                    colors: [
                        ("Main", ColorPalette.accent),
                        ("Light", ColorPalette.accentLight),
                        ("Dark", ColorPalette.accentDark)
                    ]
                )
                
                // セマンティックカラー
                ColorPaletteSection(
                    title: "Semantic Colors",
                    colors: [
                        ("Success", ColorPalette.success),
                        ("Error", ColorPalette.error),
                        ("Warning", ColorPalette.warning)
                    ]
                )
                
                // テキストカラー
                ColorPaletteSection(
                    title: "Text Colors",
                    colors: [
                        ("Primary", ColorPalette.textPrimary),
                        ("Secondary", ColorPalette.textSecondary),
                        ("Disabled", ColorPalette.textDisabled)
                    ]
                )
                
                // 背景カラー
                ColorPaletteSection(
                    title: "Background Colors",
                    colors: [
                        ("Primary", ColorPalette.backgroundPrimary),
                        ("Secondary", ColorPalette.backgroundSecondary),
                        ("Tertiary", ColorPalette.backgroundTertiary)
                    ]
                )
                
                // 使用例
                UsageExamplesSection()
            }
            .padding()
        }
    }
}

// カラーパレットのセクション
struct ColorPaletteSection: View {
    let title: String
    let colors: [(String, Color)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundColor(ColorPalette.textPrimary)
            
            ForEach(colors, id: \.0) { name, color in
                HStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(color)
                        .frame(width: 60, height: 60)
                    
                    VStack(alignment: .leading) {
                        Text(name)
                            .foregroundColor(ColorPalette.textPrimary)
                        Text(color.toHex() ?? "")
                            .font(.caption)
                            .foregroundColor(ColorPalette.textSecondary)
                    }
                }
            }
        }
    }
}

// 使用例セクション
struct UsageExamplesSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Usage Examples")
                .font(.headline)
                .foregroundColor(ColorPalette.textPrimary)
            
            // ボタン例
            VStack(spacing: 10) {
                Button("Primary Button") {}
                    .buttonStyle(PrimaryButtonStyle())
                
                Button("Secondary Button") {}
                    .buttonStyle(SecondaryButtonStyle())
                
                Button("Accent Button") {}
                    .buttonStyle(AccentButtonStyle())
            }
            
            // カード例
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorPalette.backgroundSecondary)
                .frame(height: 100)
                .overlay(
                    Text("Card Example")
                        .foregroundColor(ColorPalette.textPrimary)
                )
        }
    }
}

// ボタンスタイル
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(ColorPalette.primary)
            .foregroundColor(.white)
            .cornerRadius(8)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(ColorPalette.secondary)
            .foregroundColor(.white)
            .cornerRadius(8)
    }
}

struct AccentButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(ColorPalette.accent)
            .foregroundColor(.white)
            .cornerRadius(8)
    }
}

// カラー拡張
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    func toHex() -> String? {
        let uiColor = UIColor(self)
        guard let components = uiColor.cgColor.components else { return nil }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        return String(format: "#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
    }
}

#Preview {
    ColorSystemPreview()
} 