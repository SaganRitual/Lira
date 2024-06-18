// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation

struct TapInfo {
    let control: Bool
    let entity: Entity?
    let positionInScene: CGPoint
    let shift: Bool

    static func tap(_ entity: Entity?, _ mouseContact: SceneInputManager.MouseContact) -> TapInfo {
        TapInfo(entity, mouseContact)
    }

    private init(_ entity: Entity?, _ mouseContact: SceneInputManager.MouseContact) {
        self.control = mouseContact.control
        self.shift = mouseContact.shift
        self.entity = entity
        self.positionInScene = mouseContact.sceneStart
    }
}
