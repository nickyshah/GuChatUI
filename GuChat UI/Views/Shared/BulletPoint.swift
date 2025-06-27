import SwiftUI

struct BulletPoint: View {
    let text: String
    let isValid: Bool
    let shouldHighlightInvalid: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Circle()
                .frame(width: 5, height: 5)
                .foregroundColor(color)
                .offset(y: 8)

            Text(text)
                .font(.body)
                .foregroundColor(color)
        }
    }

    private var color: Color {
        if isValid {
            return .green // Real-time green when valid
        } else if shouldHighlightInvalid {
            return .red // Only red after validation attempt
        } else {
            return .black // Default before interaction
        }
    }
}
