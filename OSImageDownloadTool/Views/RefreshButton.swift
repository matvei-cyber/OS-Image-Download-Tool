import SwiftUI

struct RefreshButton: View {
    var action: () -> Void

    @State private var isHovered = false

    var body: some View {
        Button(action: {
            action()
        }) {
            Image(systemName: "arrow.clockwise")
                .rotationEffect(.degrees(isHovered ? 360 : 0))
                .animation(.easeInOut(duration: 0.6), value: isHovered)
                .frame(width: 28, height: 20)
                .background(
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill(isHovered ? Color.gray.opacity(0.25) : Color.gray.opacity(0.15))
                )
                .contentShape(RoundedRectangle(cornerRadius: 6))
        }
        .buttonStyle(PlainButtonStyle())
        .padding(10)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}
