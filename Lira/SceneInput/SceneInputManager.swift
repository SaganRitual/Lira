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

    func drag(_ startVertex: CGPoint, _ endVertex: CGPoint, _ control: Bool, _ shift: Bool) {
        dragManager.drag(startVertex: startVertex, endVertex: endVertex, control, shift)
    }

    func dragEnd(_ startVertex: CGPoint, _ endVertex: CGPoint, _ control: Bool, _ shift: Bool) {
        dragManager.dragEnd(startVertex: startVertex, endVertex: endVertex, control, shift)
    }

    func tap(at position: CGPoint, _ control: Bool, _ shift: Bool) {
        tapManager.tap(at: position, control, shift)
    }
}
