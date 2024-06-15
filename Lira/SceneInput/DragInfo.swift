// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation
import SpriteKit

struct DragInfo {
    enum Phase { case begin, `continue`, end }

    let control: Bool
    let endVertex: CGPoint
    let entity: Entity?
    let phase: Phase
    let shift: Bool
    let startVertex: CGPoint
    let sceneNode: SKNode?

    static func begin(_ entity: Entity?, _ startVertex: CGPoint, _ endVertex: CGPoint, _ control: Bool, _ shift: Bool) -> DragInfo {
        DragInfo(.begin, entity, startVertex, endVertex, control, shift)
    }

    static func `continue`(_ entity: Entity?, _ startVertex: CGPoint, _ endVertex: CGPoint, _ control: Bool, _ shift: Bool) -> DragInfo {
        DragInfo(.continue, entity, startVertex, endVertex, control, shift)
    }

    static func end(_ entity: Entity?, _ startVertex: CGPoint, _ endVertex: CGPoint, _ control: Bool, _ shift: Bool) -> DragInfo {
        DragInfo(.end, entity, startVertex, endVertex, control, shift)
    }

    private init(_ phase: Phase, _ entity: Entity?, _ startVertex: CGPoint, _ endVertex: CGPoint, _ control: Bool, _ shift: Bool) {
        self.phase = phase
        self.startVertex = startVertex
        self.endVertex = endVertex
        self.control = control
        self.shift = shift

        self.entity = entity
        self.sceneNode = nil
    }
}
