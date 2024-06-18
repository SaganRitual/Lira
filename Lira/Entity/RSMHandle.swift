// We are a way for the cosmos to know itself. -- C. Sagan

import Combine
import Foundation
import SpriteKit

extension Entities {

    final class RSMHandle: MoveHandle, Entities.Feature.Rotatable, Entities.Feature.Scalable {
        let rosizeHandles: [SpriteWorld.Directions: Entities.RosizeHandle]

        var draggingSubhandle: Entities.RosizeHandle?

        var rotation: CGFloat {
            get { shape.zRotation }

            set {
                shape.zRotation = newValue

                if var rotatable = targetEntity as? Entities.Feature.Rotatable {
                    rotatable.rotation = newValue
                }
            }
        }

        var scale: CGFloat {
            get { sqrt(2 * shape.xScale * shape.xScale) }

            set {
                shape.setScale(newValue)

                rosizeHandles.values.forEach { handle in
                    handle.scale = 1 / newValue
                }

                if var scalable = targetEntity as? Entities.Feature.Scalable {
                    scalable.scale = newValue
                }
            }
        }

        override init(_ dragManager: DragManager) {
            var rh = [SpriteWorld.Directions: Entities.RosizeHandle]()
            SpriteWorld.Directions.allCases.forEach { direction in
                rh[direction] = Entities.RosizeHandle(direction, Components.MoveHandleShape.radius)
            }

            rosizeHandles = rh

            super.init(dragManager)

            rosizeHandles.forEach { (direction, handle) in
                shape.addChild(handle.shape)
            }
        }

        override func dispatchDrag(_ dragInfo: DragInfo) {
            if !(dragInfo.entity is RosizeHandle) {
                // If it's not a rosize handle, it's a move handle, which is our base class
                super.dispatchDrag(dragInfo)
                return
            }

            // It is a rosize handle

            let rosizeHandle = dragInfo.entity! as! RosizeHandle
            let ownerRSM = rosizeHandle.shape.parent!.getOwnerEntity()! as! RSMHandle

            guard self === ownerRSM || self.isActive else {
                // If not selected, ignore dragging
                return
            }

            // What we want to do here is rosize all selected entities in proportion to
            // the movement of the mouse relative to the specific handle we're dragging.
            // But it's a low-priority feature. I'm eager to get the other part of the
            // app working. Come back to this
            let ev = dragInfo.endVertexInScene
            let delta = ev - ownerRSM.position
            let distance = delta.magnitude
            let scale = distance / Components.MoveHandleShape.radius
            var rotation = atan2(delta.y, delta.x)

            switch rosizeHandle.direction {
            case .n: rotation -= .pi / 2
            case .e: rotation += 0
            case .s: rotation += .pi / 2
            case .w: rotation += .pi
            }

            switch dragInfo.phase {
            case .begin:
                draggingSubhandle = rosizeHandle
            case .continue:
                self.rotation = rotation
                self.scale = scale
            case .end:
                draggingSubhandle = nil
            }
        }
    }

}
