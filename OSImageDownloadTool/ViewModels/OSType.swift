import Foundation

enum OSType: String, CaseIterable, Identifiable {
    case macOS, Windows, Xcode

    var id: String { rawValue }
}
