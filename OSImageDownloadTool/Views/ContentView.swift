import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: ImageListViewModel

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 16) {
                // Заголовок
                Text("OS Image Download Tool")
                    .font(.system(size: 28, weight: .regular))
                    .multilineTextAlignment(.center)
                    .padding(.top, 32)

                // Платформы
                Picker("", selection: $viewModel.selectedPlatform) {
                    ForEach(OSType.allCases) { plat in
                        Text(plat.rawValue).tag(plat)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                // Список + кнопка обновления
                ZStack(alignment: .bottomTrailing) {
                    List(selection: $viewModel.selectedItem) {
                        ForEach(viewModel.items) { item in
                            ImageRowView(item: item)
                                .tag(item)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .layoutPriority(1)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                    RefreshButton {
                        viewModel.refresh()
                    }
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                // Кнопка загрузки
                Button(action: viewModel.startDownload) {
                    HStack {
                        Image(systemName: "play.fill")
                        Text("Download")
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 6)
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .disabled(viewModel.selectedItem == nil || viewModel.isDownloading)

                // Прогресс-бар
                if viewModel.isDownloading {
                    VStack(spacing: 6) {
                        ProgressBarView(progress: viewModel.downloadProgress)
                            .frame(height: 4)
                            .padding(.horizontal)

                        HStack {
                            Spacer()
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                            Text("Downloading...")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal)
                    }
                }

                Spacer(minLength: 20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .frame(minWidth: 600, minHeight: 500)
    }
}
