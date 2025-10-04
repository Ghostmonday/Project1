import SwiftUI
import UIKit

// MARK: - Accessibility Helpers
// Simplified version for iOS 16.0+ compatibility

struct AccessibilityHelpers {
    // MARK: - Currency Formatting
    
    static func currencyAccessibilityLabel(_ amount: Double, currency: String = "USD") -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        return formatter.string(from: NSNumber(value: amount)) ?? "\(amount) dollars"
    }
    
    // MARK: - Participant Information
    
    static func participantAccessibilityLabel(name: String, role: String, amount: Double?) -> String {
        var label = "\(name), \(role)"
        if let amount = amount {
            label += ", receives \(currencyAccessibilityLabel(amount))"
        }
        return label
    }
    
    // MARK: - Dynamic Type Support
    
    static func scaledFont(_ style: Font.TextStyle, size: CGFloat? = nil) -> Font {
        if let size = size {
            return Font.system(size: size, design: .default)
        } else {
            return Font.system(style)
        }
    }
}

// MARK: - Accessibility View Modifiers

struct AccessibilityAction: ViewModifier {
    let label: String
    let hint: String?
    let traits: AccessibilityTraits
    let value: String?
    
    init(
        label: String,
        hint: String? = nil,
        traits: AccessibilityTraits = [],
        value: String? = nil
    ) {
        self.label = label
        self.hint = hint
        self.traits = traits
        self.value = value
    }
    
    func body(content: Content) -> some View {
        content
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
            .accessibilityAddTraits(traits)
            .accessibilityValue(value ?? "")
    }
}

extension View {
    func accessibilityAction(
        label: String,
        hint: String? = nil,
        traits: AccessibilityTraits = [],
        value: String? = nil
    ) -> some View {
        modifier(AccessibilityAction(label: label, hint: hint, traits: traits, value: value))
    }
    
    func accessibilityFocus(_ isFocused: Bool) -> some View {
        self
    }
}

// MARK: - Dynamic Font Size View

struct DynamicFontView<Content: View>: View {
    let content: Content
    let style: Font.TextStyle
    let baseSize: CGFloat
    let lineSpacing: CGFloat
    
    init(
        style: Font.TextStyle = .body,
        baseSize: CGFloat = 16,
        lineSpacing: CGFloat = 4,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.style = style
        self.baseSize = baseSize
        self.lineSpacing = lineSpacing
    }
    
    var body: some View {
        content
            .font(.system(style))
            .lineSpacing(lineSpacing)
    }
}

// MARK: - Accessibility Announcements

struct AccessibilityAnnouncer {
    static func announce(_ message: String, priority: Bool = true) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIAccessibility.post(notification: .announcement, argument: message)
        }
    }
    
    static func announceScreenChange(_ screenName: String) {
        announce("\(screenName) screen")
    }
    
    static func announceSuccess(_ message: String) {
        announce("Success: \(message)")
    }
    
    static func announceError(_ message: String) {
        announce("Error: \(message)", priority: true)
    }
}

// MARK: - Accessibility Environment Values

struct AccessibilityReduceMotionKey: EnvironmentKey {
    static let defaultValue = false
}

struct AccessibilityDifferentiateWithoutColorKey: EnvironmentKey {
    static let defaultValue = false
}

extension EnvironmentValues {
    var accessibilityReduceMotion: Bool {
        get { self[AccessibilityReduceMotionKey.self] }
        set { self[AccessibilityReduceMotionKey.self] = newValue }
    }
    
    var accessibilityDifferentiateWithoutColor: Bool {
        get { self[AccessibilityDifferentiateWithoutColorKey.self] }
        set { self[AccessibilityDifferentiateWithoutColorKey.self] = newValue }
    }
}

// MARK: - Accessibility-Aware Layout

struct AccessibilityAwareStack<Content: View>: View {
    let content: Content
    let horizontalAlignment: HorizontalAlignment
    let verticalAlignment: VerticalAlignment
    let spacing: CGFloat
    
    @Environment(\.sizeCategory) private var sizeCategory
    
    init(
        horizontalAlignment: HorizontalAlignment = .center,
        verticalAlignment: VerticalAlignment = .center,
        spacing: CGFloat = 8,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
        self.spacing = spacing
    }
    
    var body: some View {
        if sizeCategory >= .accessibilityMedium {
            VStack(alignment: horizontalAlignment, spacing: spacing) {
                content
            }
        } else {
            HStack(alignment: verticalAlignment, spacing: spacing) {
                content
            }
        }
    }
}

// MARK: - VoiceOver Focus Management

struct VoiceOverFocusModifier: ViewModifier {
    let shouldFocus: Bool
    
    func body(content: Content) -> some View {
        content
            .accessibilityFocused(shouldFocus)
    }
}

extension View {
    func accessibilityFocused(_ shouldFocus: Bool) -> some View {
        self
    }
}

// MARK: - Accessibility Testing Helpers

#if DEBUG
struct AccessibilityTestHelpers {
    static func printAccessibilityTree(for view: some View) {
        print("Accessibility tree for view: \(type(of: view))")
        // Implementation would use Mirror or similar for debug purposes
    }
    
    static func validateAccessibilityLabels(_ labels: [String]) -> Bool {
        labels.allSatisfy { !$0.isEmpty && $0.count > 3 }
    }
}
#endif
