//
//  ContentView.swift
//  OS Image Download Tool
//
//  Created by Матвей on 2025-07-03.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: ImageListViewModel

    var body: some View {
        VStack(alignment: .leading) {
            // MARK: — Сегментированный контрол и кнопка обновления
            HStack {
                Picker("Платформа", selection: $viewModel.selectedPlatform) {
                    ForEach(OSType.allCases) { platform in
                        Text(platform.rawValue).tag(platform)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())

                Button(action: viewModel.refresh) {
                    Image(systemName: "arrow.clockwise")
                    Text("Обновить")
                }
                .padding(.leading, 10)
            }
            .padding([.top, .horizontal])

            // MARK: — Список образов
            List(selection: $viewModel.selectedItem) {
                ForEach(viewModel.items) { item in
                    ImageRowView(item: item)
                        .tag(item)
                }
            }
            .listStyle(PlainListStyle())
            .padding(.horizontal)

            // MARK: — Кнопка "Скачать"
            HStack {
                Button(action: { viewModel.startDownload() }) {
                    Text("Скачать")
                        .frame(minWidth: 80)
                }
                // кнопка недоступна, пока не выбран образ или уже идёт загрузка
                .disabled(viewModel.selectedItem == nil || viewModel.isDownloading)

                Spacer()
            }
            .padding([.top, .horizontal])

            // MARK: — Индикатор загрузки и прогресс-бар
            if viewModel.isDownloading {
                HStack(spacing: 8) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                    Text("Загрузка...")
                }
                .padding(.horizontal)

                ProgressBarView(progress: viewModel.downloadProgress)
                    .frame(height: 6)
                    .padding([.horizontal, .bottom])
            }
        }
        .frame(minWidth: 600, minHeight: 400)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        // Заглушечный ViewModel для превью
        let vm = ImageListViewModel.preview
        return ContentView()
            .environmentObject(vm)
    }
}
