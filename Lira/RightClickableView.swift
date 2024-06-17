// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

// Some help from Google Gemini. It took several tries to get a form
// that would actually compile, but it works now, and I didn't get
// downvotes or nasty comments about my character
struct RightClickableView: NSViewRepresentable {
    var onRightClick: () -> Void

    func makeNSView(context: Context) -> RightClickView {
        let view = RightClickView()
        view.onRightClick = onRightClick // Set the callback
        return view
    }

    func updateNSView(_ nsView: RightClickView, context: Context) {
        // Nothing to update here
    }
}

// Custom NSView Subclass
class RightClickView: NSView {
    var onRightClick: (() -> Void)?

    override func hitTest(_ point: NSPoint) -> NSView? {
        // Only handle right-clicks, let other events pass through
        guard let event = window?.currentEvent, event.type == .rightMouseDown else {
            return nil // Let the event go to views below
        }

        return super.hitTest(point) // Handle right-clicks normally
    }

    override func rightMouseDown(with event: NSEvent) {
        onRightClick?() // Call the callback if it's set
    }
}
