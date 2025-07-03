import SwiftUI

struct WindowAccessor: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            if let window = view.window {
                window.minSize = NSSize(width: 600, height: 500)
            }
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}
