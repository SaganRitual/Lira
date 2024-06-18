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
            guard let rh = rosizeHandles.first(where: { (_, handle) in handle === dragInfo.entity }) else {
                super.dispatchDrag(dragInfo)
                return
            }

            let ev = dragInfo.endVertexInScene

            let delta = ev - self.position
            let distance = delta.magnitude
            let scale = distance / Components.MoveHandleShape.radius
            var rotation = atan2(delta.y, delta.x)

            switch rh.value.direction {
            case .n: rotation -= .pi / 2
            case .e: rotation += 0
            case .s: rotation += .pi / 2
            case .w: rotation += .pi
            }

            switch dragInfo.phase {
            case .begin:
                draggingSubhandle = rh.value
            case .continue:
                self.rotation = rotation
                self.scale = scale
            case .end:
                draggingSubhandle = nil
            }
        }
    }

}
