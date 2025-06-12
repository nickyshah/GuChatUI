import SwiftUI

struct BulletPoint: View {
    let text: String
    let isValid: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Circle()
                .frame(width: 5, height: 5)
                .foregroundColor(isValid ? .green : .black)
                .offset(y: 8)

            Text(text)
                .font(.body)
                .foregroundColor(isValid ? .green : .black)
        }
    }
}
