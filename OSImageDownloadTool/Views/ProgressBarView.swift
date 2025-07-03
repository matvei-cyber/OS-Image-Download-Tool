//
//  ProgressBarView.swift
//  OS Image Download Tool
//
//  Created by Матвей on 2025-07-03.
//

import SwiftUI

struct ProgressBarView: View {
    /// Значение прогресса от 0.0 до 1.0
    let progress: Double
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                // Фон трека
                RoundedRectangle(cornerRadius: geo.size.height / 2)
                    .frame(height: geo.size.height)
                    .opacity(0.2)
                
                // Заполненная часть
                RoundedRectangle(cornerRadius: geo.size.height / 2)
                    .frame(width: max(min(CGFloat(progress) * geo.size.width, geo.size.width), 0),
                           height: geo.size.height)
                    .animation(.easeInOut(duration: 0.2), value: progress)
            }
        }
        // Минимальная высота, чтобы корректно отрисовывался cornerRadius
        .frame(minHeight: 4)
    }
}

struct ProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 12) {
            ProgressBarView(progress: 0.0)
                .frame(height: 6)
                .padding(.horizontal)
            ProgressBarView(progress: 0.3)
                .frame(height: 6)
                .padding(.horizontal)
            ProgressBarView(progress: 0.6)
                .frame(height: 6)
                .padding(.horizontal)
            ProgressBarView(progress: 1.0)
                .frame(height: 6)
                .padding(.horizontal)
        }
        .previewLayout(.sizeThatFits)
    }
}
