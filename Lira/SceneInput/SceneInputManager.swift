// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation

final class SceneInputManager: ObservableObject {
    let dragManager = DragManager()
    let tapManager = TapManager()

    init(_ scene: SpriteWorld.Scene) {
        
    }

    func drag(_ startVertex: CGPoint, _ endVertex: CGPoint, _ control: Bool, _ shift: Bool) {

    }

    func dragEnd(_ startVertex: CGPoint, _ endVertex: CGPoint, _ control: Bool, _ shift: Bool) {

    }

    func tap(at position: CGPoint, _ control: Bool, _ shift: Bool) {

    }
}
