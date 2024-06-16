// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation
import SpriteKit

extension Entities {

    final class Gremlin:
        SelectableEntity,
        Entities.Feature.HasAvatarSprite,
        Entities.Feature.Positionable,
        Entities.Feature.Rotatable,
        Entities.Feature.Scalable,
        Entities.Feature.HasMoveHandle,
        Entities.Feature.HasRSMHandle
    {
        private var rh: Entities.RSMHandle!
        var moveHandle: Entities.MoveHandle { rh }
        var rsmHandle: Entities.RSMHandle { rh }

        override var isSelected: Bool { moveHandle.isActive }

        let sprite: Components.AvatarSprite

        var position: CGPoint {
            get { sprite.position }
            set { sprite.position = newValue }
        }

        var rotation: CGFloat {
            get { sprite.zRotation }
            set { sprite.zRotation = newValue }
        }

        var scale: CGFloat {
            get { sqrt(2 * sprite.xScale * sprite.xScale) }
            set { sprite.setScale(newValue) }
        }

        private init(_ position: CGPoint) {
            self.sprite = Components.AvatarSprite("cyclops", position)

            super.init()

            self.sprite.setOwnerEntity(self)
        }

        private func setMoveHandle(_ moveHandle: Entities.RSMHandle) {
            self.rh = moveHandle
            moveHandle.shape.position = sprite.position
        }

        override func deselect() {
            moveHandle.deactivate()
        }

        override func select() {
            moveHandle.activate()
        }

        override func toggleSelect() {
            moveHandle.toggleActivation()
        }

        static func makeGremlin(
            at position: CGPoint,
            parentSceneNode: SKNode,
            dragManager: DragManager
        ) -> Gremlin {
            let moveHandle = RSMHandle(dragManager)
            let gremlin = Gremlin(position)

            parentSceneNode.addChild(gremlin.sprite)
            parentSceneNode.addChild(moveHandle.shape)

            gremlin.setMoveHandle(moveHandle)
            moveHandle.setTargetEntity(gremlin)

            return gremlin
        }
    }

}
