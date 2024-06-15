// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation
import SpriteKit

enum Entities {
    enum Feature { }
}

class Entity {
    let isHandle = false
    let isSelectable = false
}

extension Entities.Feature {

    protocol HasAvatarShape {
        var shape: SKShapeNode { get }
    }

    protocol HasAvatarSprite {
        var sprite: SKSpriteNode { get }
    }

    protocol HasMoveHandle {
        var moveHandle: Entities.MoveHandle { get }
    }

    protocol HasRosizeHandles {
        var rosizeHandles: [Entities.RosizeHandle] { get }
    }

    protocol IsDraggable {
        func dragBegin(_ startVertex: CGPoint, _ endVertex: CGPoint, _ control: Bool, _ shift: Bool)
        func dragContinue(_ startVertex: CGPoint, _ endVertex: CGPoint, _ control: Bool, _ shift: Bool)
        func dragEnd(_ startVertex: CGPoint, _ endVertex: CGPoint, _ control: Bool, _ shift: Bool)
    }

}
