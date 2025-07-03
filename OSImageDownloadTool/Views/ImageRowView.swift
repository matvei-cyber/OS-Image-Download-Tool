import SwiftUI

struct ImageRowView: View {
    let item: ImageItem

    var body: some View {
        HStack {
            Image(systemName: "doc.fill")
                .foregroundColor(.blue)
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                Text(item.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }
}
