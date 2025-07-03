import Foundation

struct DownloadService {
    static func download(from url: URL, progressHandler: @escaping (Double) -> Void, completion: @escaping () -> Void) {
        let task = URLSession.shared.downloadTask(with: url) { tempURL, response, error in
            guard tempURL != nil, error == nil else {
                DispatchQueue.main.async { completion() }
                return
            }
            DispatchQueue.main.async { completion() }
        }

        task.resume()
    }
}
