import Foundation
import Combine

class ImageListViewModel: ObservableObject {
    @Published var items: [ImageItem] = []
    @Published var selectedItem: ImageItem? = nil
    @Published var selectedPlatform: OSType = .macOS
    @Published var isDownloading = false
    @Published var downloadProgress: Double = 0.0

    private var cancellables = Set<AnyCancellable>()

    func refresh() {
        RemoteService.fetchImages(for: selectedPlatform) { [weak self] newItems in
            DispatchQueue.main.async {
                self?.items = newItems
            }
        }
    }

    func startDownload() {
        guard let item = selectedItem else { return }
        isDownloading = true
        downloadProgress = 0.0

        DownloadService.download(from: item.url) { [weak self] progress in
            DispatchQueue.main.async {
                self?.downloadProgress = progress
            }
        } completion: { [weak self] in
            DispatchQueue.main.async {
                self?.isDownloading = false
            }
        }
    }
}
