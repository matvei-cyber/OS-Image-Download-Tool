//
//  ImageRowView.swift
//  OS Image Download Tool
//
//  Created by Матвей on 2025-07-03.
//

import SwiftUI

struct ImageRowView: View {
    let item: ImageItem

    private var formattedSize: String {
        // Форматируем размер в человекочитаемый вид
        ByteCountFormatter.string(fromByteCount: Int64(item.size), countStyle: .file)
    }

    var body: some View {
        HStack {
            // Название образа
            Text(item.name)
                .font(.system(size: 14, weight: .regular, design: .monospaced))
                .lineLimit(1)

            Spacer()

            // Размер файла
            Text(formattedSize)
                .font(.system(size: 12))
                .foregroundColor(.secondary)

            // Тип ОС
            Text(item.osType.rawValue)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
                .padding(.leading, 8)
        }
        .padding(.vertical, 4)
    }
}

struct ImageRowView_Previews: PreviewProvider {
    static var previews: some View {
        // Пример заглушки для превью
        let sample = ImageItem(
            id: UUID(),
            name: "macOS_Ventura.iso",
            url: URL(string: "https://example.com/macos_vventura.iso")!,
            size: 8_589_934_592,    // 8 ГБ
            osType: .macOS
        )
        return ImageRowView(item: sample)
            .previewLayout(.fixed(width: 600, height: 30))
            .padding(.horizontal)
    }
}
