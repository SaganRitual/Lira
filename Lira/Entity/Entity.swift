// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation
import SpriteKit

enum Entities {
    enum Feature { }
}

class Entity: NSObject {
    var isHandle: Bool { false }
    let uuid = UUID()
}

class SelectableEntity: Entity, Entities.Feature.IsSelectable {
    var isSelected: Bool { false }

    func deselect() { }
    func select() { }
    func toggleSelect() { }
}

extension Entities.Feature {

    protocol HasAvatarShape {
        var shape: Components.AvatarShape { get }
    }

    protocol HasAvatarSprite {
        var sprite: Components.AvatarSprite { get }
    }

    protocol HasMoveHandle {
        var moveHandle: Entities.MoveHandle { get }
    }

    protocol HasRSMHandle {
        var rsmHandle: Entities.RSMHandle { get }
    }

    protocol HasRosizeHandles {
        var rosizeHandles: [Entities.RosizeHandle] { get }
    }

    protocol IsDraggable {
        func dragBegin(_ startVertex: CGPoint, _ endVertex: CGPoint, _ control: Bool, _ shift: Bool)
        func dragContinue(_ startVertex: CGPoint, _ endVertex: CGPoint, _ control: Bool, _ shift: Bool)
        func dragEnd(_ startVertex: CGPoint, _ endVertex: CGPoint, _ control: Bool, _ shift: Bool)
    }

    protocol IsSelectable {
        var isSelected: Bool { get }

        func deselect()
        func select()
        func toggleSelect()
    }

    protocol Positionable {
        var position: CGPoint { get set }
    }

    protocol Rotatable {
        var rotation: CGFloat { get set }
    }

    protocol Scalable {
        var scale: CGFloat { get set }
    }

}
