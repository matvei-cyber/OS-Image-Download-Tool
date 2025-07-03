import SwiftUI

struct ProgressBarView: View {
    var progress: Double // от 0.0 до 1.0

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Color.gray.opacity(0.2))
                Rectangle()
                    .foregroundColor(.blue)
                    .frame(width: geometry.size.width * CGFloat(progress))
            }
            .cornerRadius(4.0)
        }
    }
}
