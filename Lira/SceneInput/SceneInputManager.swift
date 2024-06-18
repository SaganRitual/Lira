// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation

final class SceneInputManager: ObservableObject {
    let dragManager: DragManager
    let tapManager: TapManager

    init(
        _ dragManager: DragManager,
        _ tapManager: TapManager
    ) {
        self.dragManager = dragManager
        self.tapManager = tapManager
    }

    func drag(_ mouseContact: MouseContact) {
        dragManager.drag(mouseContact)
    }

    func dragEnd(_ mouseContact: MouseContact) {
        dragManager.dragEnd(mouseContact)
    }

    func rightClick(_ mouseContact: MouseContact) {
        print("right click at \(mouseContact.sceneStart)")
    }

    func tap(_ mouseContact: MouseContact) {
        tapManager.tap(mouseContact)
    }
}
