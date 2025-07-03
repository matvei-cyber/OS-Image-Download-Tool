import Foundation

struct RemoteService {
    static func fetchImages(for platform: OSType, completion: @escaping ([ImageItem]) -> Void) {
        // Это заглушка. Можно заменить реальной загрузкой JSON с сервера.
        let mockData = [
            ImageItem(name: "macOS Ventura", description: "Latest official installer", url: URL(string: "https://example.com/macos.dmg")!),
            ImageItem(name: "Windows 11 ISO", description: "English, 64-bit", url: URL(string: "https://example.com/windows.iso")!),
            ImageItem(name: "Xcode 15.2", description: "Xcode .xip archive", url: URL(string: "https://example.com/xcode.xip")!)
        ]
        completion(mockData.filter {
            switch platform {
            case .macOS: return $0.name.contains("macOS")
            case .Windows: return $0.name.contains("Windows")
            case .Xcode: return $0.name.contains("Xcode")
            }
        })
    }
}
