// We are a way for the cosmos to know itself. -- C. Sagan

import Foundation
import SpriteKit

extension Entities {

    final class Gremlin:
        SelectableEntity,
        Entities.Feature.HasAvatarSprite,
        Entities.Feature.HasMoveHandle,
        Entities.Feature.HasPosition
    {
        private var mh: Entities.MoveHandle!
        var moveHandle: Entities.MoveHandle { mh }

        override var isSelected: Bool { moveHandle.isActive }

        let sprite: SKSpriteNode

        var position: CGPoint {
            get { sprite.position }
            set { sprite.position = newValue }
        }

        private init(_ position: CGPoint) {
            self.sprite = Components.AvatarSprite("cyclops", position)

            super.init()

            self.sprite.setOwnerEntity(self)
        }

        private func setMoveHandle(_ moveHandle: Entities.MoveHandle) {
            self.mh = moveHandle
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
            let moveHandle = MoveHandle(dragManager)
            let gremlin = Gremlin(position)

            parentSceneNode.addChild(gremlin.sprite)
            parentSceneNode.addChild(moveHandle.shape)

            gremlin.setMoveHandle(moveHandle)
            moveHandle.setTargetEntity(gremlin)

            return gremlin
        }
    }

}
