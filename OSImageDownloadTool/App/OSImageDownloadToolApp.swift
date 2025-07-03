import SwiftUI

@main
struct OSImageDownloadToolApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ImageListViewModel())
                .background(WindowAccessor())
        }
    }
}
