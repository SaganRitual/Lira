// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation
import SpriteKit

struct DragInfo {
    enum Phase { case begin, `continue`, end }

    let control: Bool
    let endVertexInScene: CGPoint
    let entity: Entity?
    let phase: Phase
    let shift: Bool
    let startVertexInScene: CGPoint

    static func begin(_ entity: Entity?, _ mouseContact: SceneInputManager.MouseContact) -> DragInfo {
        DragInfo(.begin, entity, mouseContact)
    }

    static func `continue`(_ entity: Entity?, _ mouseContact: SceneInputManager.MouseContact) -> DragInfo {
        DragInfo(.continue, entity, mouseContact)
    }

    static func end(_ entity: Entity?, _ mouseContact: SceneInputManager.MouseContact) -> DragInfo {
        DragInfo(.end, entity, mouseContact)
    }

    private init(_ phase: Phase, _ entity: Entity?, _ mouseContact: SceneInputManager.MouseContact) {
        self.phase = phase
        self.startVertexInScene = mouseContact.sceneStart
        self.endVertexInScene = mouseContact.sceneEnd
        self.control = mouseContact.control
        self.shift = mouseContact.shift

        self.entity = entity
    }
}
